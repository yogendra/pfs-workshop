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
  # Create rolebinding under user ns
  kubectl create rolebinding ${rolebinding} --serviceaccount=${ns_user_name} --clusterrole=admin -n ${namespace}
  # Create rolebinding under default ns
  kubectl create rolebinding ${rolebinding} --serviceaccount=${ns_user_name} --clusterrole=admin -n default
  # Create rolebinding under knative service
  kubectl create rolebinding ${rolebinding} --serviceaccount=${ns_user_name} --clusterrole=view -n knative-serving

  user_token=$(kubectl get secret $(kubectl get sa $user_name -n ${namespace} -o json | jq -r .secrets[0].name) -n ${namespace} -o json | jq -r .data.token | base64 -d)

  mkdir -p $user_root
  cat <<EOF > $config_file
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $kubernetes_ca
    server: https://${kubernetes_host}:8443
  name: workshop-cluster
contexts:
- context:
    cluster: workshop-cluster
    namespace: $namespace
    user: $user_name
  name: workshop
current-context: workshop
kind: Config
preferences: {}
users:
- name: $user_name
  user:
    token: $user_token
EOF

  pfs --kubeconfig $config_file namespace init --image-prefix $image_prefix/$namespace --namespace $namespace


  echo Finished creating user:$user ns:$namespace and config:$config_file
}



run prepare_account $*
