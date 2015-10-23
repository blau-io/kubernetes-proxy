#!/bin/sh
set -euf

# Loop until Confd created the first config gile
until /usr/bin/confd -onetime \
            -node 127.0.0.1:4001 \
            -config-file /etc/confd/conf.d/nginx.toml
do sleep 5
done

# Start Confd
echo "Starting Confd"
/usr/bin/confd -interval 10 \
      -node 127.0.0.1:4001 \
      -config-file /etc/confd/conf.d/nginx.toml &

# Start Nginx
echo "Starting Nginx"
/etc/init.d/nginx start
