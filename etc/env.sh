
#ROOT_OF_PROJECT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


[ -z "$SITE_NAME" ] && { echo "SITE_NAME is not specified" ; exit 1 ; } || { echo "SITE_NAME is: $SITE_NAME" ; }


TZ='Europe/Sofia'
DEF_APS="aps_"
DEF_NC="nc_"
NETWORK_NAME="nginx-aps-db-net"
DB_CONTAINER_NAME='mariadb-aps'
DB_ROOT_PASSWORD='FL6wWnxVj76Anc9gg'

NGINX_CONTAINER="nginx-rev-proxy"

VOLUMES="/data/volumes/${SITE_NAME}"

CRTBOT_ETC="${VOLUMES}/certbot/etc/"
CRTBOT_VAR="${VOLUMES}/certbot/var/"

APS_VOLUMES="${VOLUMES}/aps/"
NC_VOLUMES="${VOLUMES}/nc/"
NGINX_CONFIG="${VOLUMES}/ngings_config/config.d"
DB_VOLUME="${VOLUMES}/mariadb-apa"

NC_IMAGE=ncld-apa-25

LOG_COMMAND_FILE=${VOLUMES}/logfile

log_command(){
    date "+%s" >> $LOG_COMMAND_FILE
    sets=$-
    exec 66>>$LOG_COMMAND_FILE
    BASH_XTRACEFD=66
    set -x
    $@
    set +x
    exec 66>&-      # Restore stdout and close file descriptor #6.
    if [[ "$sets" == *"x"* ]] ; then
        set -x
        cat $LOG_COMMAND_FILE
    fi

}
