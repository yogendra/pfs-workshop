#!/usr/bin/env bash

source `dirname $0`/variables.sh

SCRIPT_ROOT=$(cd  `dirname $0`; pwd)

function get_config {

    i=$1
    user=user-$i
    user_name=$user
    namespace=$user_name-ns
    user_root=$users_root/$user
    config_file=$user_root/config

    echo "Getting token"
    user_token=$(kubectl get secret $(kubectl get sa $user_name -n ${namespace} -o json | jq -r .secrets[0].name) -n ${namespace} -o json | jq -r .data.token | base64 -d)
    
    [[ ! -e $user_root ]] && mkdir -p $user_root
    echo "writing $config_file"
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
}

run get_config $*
