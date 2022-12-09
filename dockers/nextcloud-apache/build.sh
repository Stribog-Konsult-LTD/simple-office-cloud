#! /bin/bash

pushd $(dirname $0)

source ../../etc/env.sh

docker build -t $NC_IMAGE .


popd
