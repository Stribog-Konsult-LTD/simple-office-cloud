#!/bin/bash 


pushd $(dirname $0)
source etc/env.sh


MARIA_DB_IMG="mariadb:10"


# it is optional can  be DB_EXPOSE_PORT=''
DB_EXPOSE_PORT='-p 172.17.0.1:3306:3306'



initMysql(){
docker run -itd \
   --name=$DB_CONTAINER_NAME \
   --hostname=$DB_CONTAINER_NAME \
   --network=${NETWORK_NAME} \
   -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
   ${DB_EXPOSE_PORT} \
   -v ${DB_VOLUME}:/var/lib/mysql \
   --restart unless-stopped \
   --log-opt max-size=10m --log-opt max-file=5 \
   -d \
   $MARIA_DB_IMG
   
   for i in `seq 1 200`;   do
    docker logs $DB_CONTAINER_NAME | grep "3306  mariadb.org binary distribution"
    [ "$?" -eq 0 ] && break;
    echo "MySql container is steel not ready! Try $i / 200 Please wait..."
    sleep 2
done

}


docker ps | grep $DB_CONTAINER_NAME

[ $? -ne 0 ] && initMysql || echo $DB_CONTAINER_NAME already running



popd
