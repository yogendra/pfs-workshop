#!/usr/bin/env bash

source `dirname $0`/variables.sh

SCRIPT_ROOT=$(cd  `dirname $0`; pwd)


function prepare_account {
  user=user-$i
  namespace=${user}-ns
  rolebinding=${user_name}-rb

  user_root=$SCRIPT_ROOT/users/$user
  config_file=$user_root/config

  user_name=$user
  ns_user_name=${namespace}:${user_name}

  # Create namespace
  kubectl create ns ${namespace}
  
  # Create user
  kubectl create sa ${user_name} -n ${namespace}
  
  # Add permisssion
  kubectl create rolebinding ${user}-rb --serviceaccount=${ns_user_name} --clusterrole=cluster-admin -n ${namespace}
  kubectl create rolebinding ${user}-rb --serviceaccount=${ns_user_name} --clusterrole=cluster-admin -n default
  kubectl create rolebinding ${user}-rb --serviceaccount=${ns_user_name} --clusterrole=cluster-admin -n knative-build
  kubectl create rolebinding ${user}-rb --serviceaccount=${ns_user_name} --clusterrole=cluster-admin -n knative-eventing
  kubectl create rolebinding ${user}-rb --serviceaccount=${ns_user_name} --clusterrole=cluster-admin -n knative-serving
  kubectl create rolebinding ${user}-rb --serviceaccount=${ns_user_name} --clusterrole=cluster-admin -n kube-system
  
  ns_image_prefix=$image_prefix/$user


  pfs namespace init \
    --kubeconfig $KUBECONFIG \
    --image-prefix $ns_image_prefix \
    -m $PWD/pfs-download/manifest.yaml \
    --gcr $gcr_json \
    $namespace
}


run prepare_account $*
