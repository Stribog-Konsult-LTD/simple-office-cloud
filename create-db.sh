#!/bin/bash


pushd $(dirname $0) > /dev/null
source etc/env.sh

usage() { echo "
    Create database and user.
    usage: $0
        -d <db>
        -w <db_pass>
        -u <db user>
        " 1>&2; exit 1; }



while getopts ":p:u:d:" o; do
    case "${o}" in
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


isDatabaseExists(){
    local tableName="$1"
    echo "show databases like '${tableName}';" >  "/tmp/check-${tableName}.sql"
    result=$( docker exec -i ${DB_CONTAINER_NAME} \
            sh -c "exec mysql -uroot -p\"${DB_ROOT_PASSWORD}\" -s -N  " <  "/tmp/check-${tableName}.sql"  )

    if [ "${result}" == "${tableName}" ] ; then
        echo "yes"
    else
        echo "no"
    fi
}

if [ -n "$CREATE_DB" ] ; then
    if [ -n "$CREATE_DB_USER" ] ; then
        if [ -n "$CREATE_DB_USER_PASS" ] ; then
            if [ "$(isDatabaseExists ${CREATE_DB})" == "no" ] ; then
                CREATE_DB=${CREATE_DB}
                docker exec -i ${DB_CONTAINER_NAME} \
                    sh -c "exec mysql -uroot \-p'${DB_ROOT_PASSWORD}' \-e \"CREATE DATABASE ${CREATE_DB}\""
                docker exec -i ${DB_CONTAINER_NAME} \
                    sh -c "exec  mysql -uroot \-p'${DB_ROOT_PASSWORD}'  -e \"GRANT ALL PRIVILEGES ON ${CREATE_DB}.* TO ${CREATE_DB_USER}@'%' IDENTIFIED BY '${CREATE_DB_USER_PASS}'\""
                exit 0
            else
                echo "Database ${CREATE_DB} exists!"
            fi
        fi
    fi
fi

usage



popd > /dev/null
