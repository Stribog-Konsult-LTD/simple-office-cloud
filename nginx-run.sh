#!/bin/bash
pushd $(readlink -f $(dirname $0))

source etc/env.sh

VOL_NGINX_CONFIG="${NGINX_CONFIG}"
VOL_CERTBOT_ETC="${CRTBOT_ETC}"

./create-net.sh
./db-run.sh

mkdir -p ${VOL_NGINX_CONFIG}

echo "
server {
    listen 80 default_server;
    server_name _;
    return 301 https://\$host\$request_uri;
}" > ${VOL_NGINX_CONFIG}/0-nginx.conf

docker run \
    --name ${NGINX_CONTAINER} \
    --hostname ${NGINX_CONTAINER} \
    --network=${NETWORK_NAME} \
    -v ${VOL_NGINX_CONFIG}:/etc/nginx/conf.d \
    -v ${VOL_CERTBOT_ETC}:/etc/apache2/ssl \
    -p 80:80  \
    -p 443:443  \
    --restart unless-stopped  \
    --log-opt max-size=10m --log-opt max-file=5 \
    -d \
    nginx



 ./aps-run.sh
popd
