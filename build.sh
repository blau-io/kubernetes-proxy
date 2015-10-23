#!/bin/bash
set -eufo pipefail

function check {
    for var in "$@"; do
        if ! hash $var 2>/dev/null; then
            echo "$var not found, quitting"
            exit
        fi
    done
}

# Check if we have all the tools we need
check actool curl deb2aci git go tar

# Install confd
if ! [-x "confd"]; then
    curl -o confd https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64
    chmod +x confd
fi

# Base image
deb2aci -pkg dash -pkg nginx -image kubernetes-proxy.aci \
    -manifest kubernetes-proxy.manifest.json
mkdir aci
tar -xvf kubernetes-proxy.aci -C aci/
rm -rvf kubernetes-proxy.aci

# Setup Confd
mkdir -p aci/rootfs/etc/confd/
mv -v confd aci/rootfs/usr/bin/confd
cp -av conf.d aci/rootfs/etc/confd/conf.d
cp -av templates aci/rootfs/etc/confd/templates

# Setup Nginx
rm -rvf aci/rootfs/etc/nginx/conf.d/*
cp -av nginx/nginx.conf aci/rootfs/etc/nginx/nginx.conf

# Setup Boot script
cp -av scripts/boot.sh aci/rootfs/usr/bin/boot.sh

# Pack ACI
actool build aci/ kubernetes-proxy.aci

# Clean up
rm -rvf aci
echo "finished"
