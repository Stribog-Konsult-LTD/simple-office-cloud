#!/bin/bash

pushd $(readlink -f $(dirname $0))
source etc/env.sh

docker network ls | grep ${NETWORK_NAME}
result=$?
echo result $result

if [ "$result" == 0 ] ; then
    echo "The network ${NETWORK_NAME} may be exists?"
else
    docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 ${NETWORK_NAME}
fi

popd
