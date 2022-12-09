
pushd $(dirname $0)

source './etc/env.sh'


while getopts "p:n:" o; do
    case "${o}" in
        n)
            USER_NAME=${OPTARG}
            ;;
        p)
            USER_PASS=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if [ -n "${USER_NAME}" ] ; then
    if [ -z "${USER_PASS}" ] ; then
        export USER_PASS="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')"
        echo "Password for ${USER_NAME} is: ${USER_PASS}"
        echo "The password will be saved to: ${LOG_COMMAND_FILE}"
        log_command echo "Password for ${USER_NAME} is: ${USER_PASS}"
    fi
    docker exec -it mailserver setup email add "${USER_NAME}"@${SITE_NAME} ${USER_PASS}
else
    echo "Usage $0 <-n user_name> [-p password]"
    echo "If password is not specified - random generate"
fi


popd
