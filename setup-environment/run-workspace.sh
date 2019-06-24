#!/usr/bin/env bash


source `dirname $0`/variables.sh

SCRIPT_ROOT=$(cd  `dirname $0`; pwd)


function run_workspace {
    i=$1
    user=user-$i
    port=`expr 10000 + $i`
    container_name=ws_$i
    hostname=$container_name
    image=yogendra/online-workspace:latest
    config_dir=/home/docker-user/users/$user
    config_volume=${container_name}_config
    code_volume=${container_name}_code

    docker volume create $config_volume
    docker volume create $code_volume

    docker run \
        --rm \
        -v $config_dir:/source \
        -v $config_volume:/target \
        busybox \
        cp /source/config /target/config

    docker run \
        --rm \
        -d \
        -p $port:80 \
        -v $code_volume:/code \
        -v $config_volume:/code/workspace/.kube \
        --name $container_name \
        --hostname $container_name \
        $image
}

run run_workspace $*
