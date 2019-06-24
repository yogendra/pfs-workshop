#!/usr/bin/env bash

WS_USER=$1

echo "Initializing on Docker image"

set -e

# Setup timezone
ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

#Setup packages
apt-get update
apt-get install -qqy wget unzip

# Setup PFS
chmod a+x /usr/local/bin/pfs
pfs completion bash >/etc/bash_completion.d/pfs


# Setup kubectl
curl -sLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl    
chmod a+x kubectl
mv kubectl /usr/local/bin
kubectl completion bash >/etc/bash_completion.d/kubectl

#Setup codiad
(cd /default-code; git pull --rebase)
curl -sLO https://github.com/Andr3as/Codiad-CodeGit/archive/master.zip
unzip master.zip  -d /default-code/plugins/ && rm -rf master
curl -sLO https://github.com/daeks-archive/Codiad-GitAdmin/archive/master.zip
unzip master.zip  -d /default-code/plugins/ && rm -rf master
curl -sLO https://github.com/Fluidbyte/Codiad-Terminal/archive/master.zip
unzip master.zip  -d /default-code/plugins/ && rm -rf master
