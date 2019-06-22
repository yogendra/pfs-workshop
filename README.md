# PFS Hands on Workshop

## Requirement

- Github account
- Docker Hub account

## Setup

You need following tools:

- SSH Client (ssh or putty)
- git
- pfs
- kubectl
- curl
- Text Editor / IDE

## Hosted workspace

Your instructor may have setup a workshop host for you. Get the instructions from him/her. You need to log on to the hosted workspae and all the required tools and access should be already present there.


## Configure Workspace on Local Machine

You need to log in to the kubernetes environment to be able to run all the commands and instructions in this workshop. Your instructor should provide you with `kubernetes-host`, `username`, `password` and `namespace`.

You can login to the kubernetes environemtn via following commands:\

```
kubectl config set-credentials workshop-user --username=<username> --password=<password>

kubectl config set-cluster workshop-cluster --insecure-skip-tls-verify=true --server=https://<kubernetes-host>

kubectl config set-context workshop --user=workshop-user --namespace=<namespace> --cluster=workshop-cluster

kubectl config use-context workshop
```

## Test Workspace Setup

To check that you environment is configured properly, you may run following commands.

```
kubectl get nodes
```

```
pfs service list
```

## Exercises

[Simple Function](exercise-1.md)

Create an Event based function
