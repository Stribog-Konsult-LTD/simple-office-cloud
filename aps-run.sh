#!/bin/bash 

DIR_NAME=$(readlink -f $(dirname $0))
pushd ${DIR_NAME}

source etc/env.sh

usage() { echo "
    Run apache php ssl docker and create database for it.
    usage: $0
        -n <name>       default empty
        -d <db>         default - asp_\$name
        -p <db_pass>    if not specified -  random generate and pass as env: \$DB_USER_PASS
        -u <db user>    default - asp_\$name
        " 1>&2; exit 1;
}

while getopts ":p:n:d:u:w:" o; do
    case "${o}" in
        n)
            APA_NAME=${OPTARG}
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
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))


[ -z "$CREATE_DB" ] &&  export CREATE_DB=${DEF_APS}${APA_NAME}
[ -z "$CREATE_DB_USER" ] &&  export CREATE_DB_USER=${DEF_APS}${APA_NAME}
if [ -z "$CREATE_DB_USER_PASS" ] ; then
    export CREATE_DB_USER_PASS="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')"
    export ENV_PASS="-e DB_USER_PASS=$CREATE_DB_USER_PASS "
fi

echo "ENV_PASS: $ENV_PASS"

PHP_APA_IMG="apa-php-ssl"

if [ -z "${APA_NAME}" ] ; then
    PHP_APA_CONTAINER_NAME=aps0
    SITE_PREFIX=''
else
    PHP_APA_CONTAINER_NAME=${DEF_APS}${APA_NAME}
    SITE_PREFIX="${APA_NAME}."
fi

PHP_APA_VOLUME_HTML="${APS_VOLUMES}/${PHP_APA_CONTAINER_NAME}/http"
PHP_APA_VOLUME_ETC="${CRTBOT_ETC}"


iniPhpAps(){

   ./create-db.sh -d "$CREATE_DB" -u "$CREATE_DB_USER" -p "$CREATE_DB_USER_PASS"

   docker run \
    --name=$PHP_APA_CONTAINER_NAME \
    --hostname=$PHP_APA_CONTAINER_NAME \
    --network=${NETWORK_NAME} \
    -v ${PHP_APA_VOLUME_HTML}:/var/www/html \
    -v ${PHP_APA_VOLUME_ETC}:/etc/apache2/ssl \
    -e SITE_NAME="${SITE_NAME}" \
    -e SITE_PREFIX="${SITE_PREFIX}" \
    -e DB_SERVER="$DB_CONTAINER_NAME" \
    -e DATABASE="${CREATE_DB}" \
    -e DB_USER="${CREATE_DB_USER}" \
    $ENV_PASS `# If password is auto generated, pass to the container as DB_USER_PASS` \
    --restart unless-stopped  \
    --log-opt max-size=10m --log-opt max-file=5 \
    -d \
    $PHP_APA_IMG
    
    export PHP_APA_CONTAINER_NAME=${PHP_APA_CONTAINER_NAME}
    export SITE_PREFIX=${SITE_PREFIX}
    export SITE_NAME=${SITE_NAME}
    envsubst '${PHP_APA_CONTAINER_NAME} ${SITE_PREFIX} ${SITE_NAME} '\
        <  templates/nginx-upstream.template \
        > ${NGINX_CONFIG}/nginx-${APA_NAME}.conf

    if [ ! -f "${PHP_APA_VOLUME_HTML}/index.php" ] ; then
        export SITE_PREFIX=$SITE_PREFIX
        export SITE_NAME=$SITE_NAME
        envsubst '$SITE_PREFIX $SITE_NAME' \
            < templates/benchmark.php.template \
            > "${PHP_APA_VOLUME_HTML}/index.php"
    fi

    docker restart ${NGINX_CONTAINER}

}

docker ps | grep $PHP_APA_CONTAINER_NAME

[ $? -ne 0 ] && iniPhpAps || echo $RESULTS_PHP_APA_CNAME already running

popd


