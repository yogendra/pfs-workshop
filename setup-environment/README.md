# Setup Environment for Workshop

## Setup Runtime environment

- Create PKS Cluster for PFS
  - Setup as per instructions in [PFS Setup Doc](https://docs.pivotal.io/pfs/0-2/install-on-pks-gcp.html)
- Setup DNS and LB for your cluster
- Get `kubectl` access to your cluster
- Create users using `prepare-account.sh`
- Create DNS entries for ingress for all your users using `prepare-dns.sh`

## Setup Development environment

- Need to install kubectl
- PFS
- Git
- Setup DNS
- Setup password
- Copy user config to `~/.kube/config`

## Docker Machine for Workspace

Create a docker machine with name `workspace`

```
docker-machine create \
  -d google \
  --google-disk-size 100 \
  --google-machine-type n1-standard-16 \
  --google-open-port 10000-10099/tcp \
  --google-project pa-yrampuria \
  --google-zone asia-southeast1-a \
  workspace
```

Copy all the user config into the machine

```
./prepare-accounts.sh
docker-machine scp -q -r users workspace:/home/docker-user
```

## Run docker containers for users

```
./run-workspace.sh
```
