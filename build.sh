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
    curl -SLo confd https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64
    chmod +x confd
fi

# Base image
deb2aci -pkg dash -pkg nginx -image base.aci \
        -manifest kubernetes-proxy/kubernetes-proxy.manifest.json
mkdir tmp && tar -xf base.aci -C tmp/

# Setup rootfs
cp -av kubernetes-proxy/rootfs tmp/
mv -v confd tmp/rootfs/usr/bin/confd
rm -rvf tmp/rootfs/etc/nginx/conf.d/*

# Pack ACI
echo "packing final ACI"
actool build tmp/ kubernetes-proxy.aci

# Clean up
rm -rf tmp
rm -rvf base.aci
echo "finished"
