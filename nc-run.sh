#!/bin/bash 


DIR_NAME=$(readlink -f $(dirname $0))
pushd ${DIR_NAME}

source etc/env.sh

usage() { echo "
    Run apache php ssl docker and create database for it.
    usage: $0
        -n <name>       mandatory 
        -d <db>         default - nc_\$name
        -p <db_pass>    if not specified -  random generate and pass as env: \$DB_USER_PASS
        -u <db user>    default - nc_\$name
        -a <admin name> default nc_\$name
        -w <admin pass> default random
        " 1>&2; exit 1;
}

while getopts ":p:n:d:u:w:a:" o; do
    case "${o}" in
        n)
            NC_NAME=${OPTARG}
            ;;
        d)
            CREATE_DB=${OPTARG}
            ;;
        u)
            CREATE_DB_USER=${OPTARG}
            ;;
        p)
            CREATE_DB_USER_PASS=${OPTARG}
            ;;
        a)
            ADMIN_USER=${OPTARG}
            ;;
        w)
            ADMIN_USER_PASS=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))


[ -z "$CREATE_DB" ] &&  export CREATE_DB=${DEF_NC}${NC_NAME}
[ -z "$ADMIN_USER" ] &&  export ADMIN_USER=${DEF_NC}${NC_NAME}
[ -z "$CREATE_DB_USER" ] &&  export CREATE_DB_USER=${DEF_NC}${NC_NAME}

if [ -z "$CREATE_DB_USER_PASS" ] ; then
    export CREATE_DB_USER_PASS="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')"
fi

if [ -z "$ADMIN_USER_PASS" ] ; then
    export ADMIN_USER_PASS="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')"
fi

# export ENV_PASS="-e DB_USER_PASS=$CREATE_DB_USER_PASS "


PHP_APA_IMG="apa-php-ssl"

if [ -z "${NC_NAME}" ] ; then
    usage
else
    NC_CONTAINER_NAME=${DEF_NC}${NC_NAME}
    SITE_PREFIX="${NC_NAME}."
fi

NC_VOLUME_ETC="${CRTBOT_ETC}"
NC_VOLUME="${NC_VOLUMES}/${NC_CONTAINER_NAME}"
./create-db.sh -d "$CREATE_DB" -u "$CREATE_DB_USER" -p "$CREATE_DB_USER_PASS"


log_command docker run \
    --name $NC_CONTAINER_NAME \
    --hostname $NC_CONTAINER_NAME \
    --network=${NETWORK_NAME} \
    -v ${NC_VOLUME}/nextcloud:/var/www/html \
    -v ${NC_VOLUME}/apps:/var/www/html/custom_apps \
    -v ${NC_VOLUME}/config:/var/www/html/config \
    -v ${NC_VOLUME}/data:/var/www/html/data \
    -v ${NC_VOLUME_ETC}:/etc/apache2/ssl \
    -e SITE_NAME="${SITE_NAME}" \
    -e SITE_PREFIX="${SITE_PREFIX}" \
    -e  MYSQL_HOST="$DB_CONTAINER_NAME"    \
    -e  MYSQL_DATABASE=$CREATE_DB         \
    -e  MYSQL_USER=$CREATE_DB_USER        \
    -e  MYSQL_PASSWORD=$CREATE_DB_USER_PASS    \
    -e  NEXTCLOUD_ADMIN_USER=$ADMIN_USER         \
    -e  NEXTCLOUD_ADMIN_PASSWORD=$ADMIN_USER_PASS \
    -e  ServerName=${SITE_PREFIX}${SITE_NAME} \
    -e  NEXTCLOUD_TRUSTED_DOMAINS=${SITE_PREFIX}${SITE_NAME} \
    -d \
    --restart unless-stopped \
    --log-opt max-size=10m --log-opt max-file=5 \
    ${NC_IMAGE}
  
    export PHP_APA_CONTAINER_NAME=${NC_CONTAINER_NAME}
    export SITE_PREFIX=${SITE_PREFIX}
    export SITE_NAME=${SITE_NAME}

    envsubst '${PHP_APA_CONTAINER_NAME} ${SITE_PREFIX} ${SITE_NAME} '\
        <  templates/nginx-upstream.template \
        > ${NGINX_CONFIG}/nginx-${NC_NAME}.conf

    docker restart ${NGINX_CONTAINER}

  
popd
