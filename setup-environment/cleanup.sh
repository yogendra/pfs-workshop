#!/usr/bin/env bash

source `dirname $0`/variables.sh

SCRIPT_ROOT=$(cd  `dirname $0`; pwd)

function cleanup {

    i=$1
    user=user-$i
    user_name=$user
    namespace=$user_name-ns
    user_root=$users_root/$user
    kubectl delete ns $namespace
    kubectl delete rolebinding ${user}-rb 
    kubectl delete rolebinding ${user}-rb -n knative-build
    kubectl delete rolebinding ${user}-rb -n knative-eventing
    kubectl delete rolebinding ${user}-rb -n knative-serving
    kubectl delete rolebinding ${user}-rb -n kube-system
    rm -rf $user_root
}

run cleanup $*
