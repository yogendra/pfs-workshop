#!/usr/bin/env bash

source `dirname $0`/variables.sh

SCRIPT_ROOT=$(cd  `dirname $0`; pwd)


function dns-txn {
    op=$1; shift
    gcloud dns record-sets transaction $op --zone=$managed_zone $*
}

function setup_dns_record {
  
  managed_zone=$1
  external_hostname=$2
  value=$3
  type=$4

  read -r old_ip old_ttl old_type <<<$(gcloud dns record-sets list --zone=${managed_zone} --filter="name=${external_hostname}. AND type=A" --format='value(DATA,ttl,type)')
  

  if [[ ! -z $old_ip ]] 
  then
      echo "Removing exsting record $managed_zone/$external_hostname -> $old_ip ($old_type,$old_ttl)"
      dns-txn remove $old_ip --name=${external_hostname}. --type $old_type --ttl $old_ttl
  fi
  echo "Adding record ${managed_zone}/${external_hostname}->$value ($type,300)"
  dns-txn add $value --name=${external_hostname}. --type=$type --ttl=300 
}



[[ -e transaction.yaml ]] && rm transaction.yaml
dns-txn start

# Setup Ingress A record
ingress=ing.$root_domain
setup_dns_record $managed_zone $ingress $ip A

# Setup default namespace
setup_dns_record $managed_zone \*.default.$root_domain ${ingress}. CNAME

function prepare_dns {
    user=user-$1
    namespace=$user-ns
    setup_dns_record $managed_zone \*.$namespace.$root_domain ${ingress}. CNAME
}

run prepare_dns $*

dns-txn execute
