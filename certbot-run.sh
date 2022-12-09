#!/bin/bash
pushd $(readlink -f $(dirname $0))

source etc/env.sh

docker run -it \
    --rm \
    --name certbot \
    --hostname certbot \
    -v "${CRTBOT_ETC}letsencrypt:/etc/letsencrypt" \
    -v "${CRTBOT_VAR}/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot  certonly --manual -d "$SITE_NAME,*.$SITE_NAME"

popd
