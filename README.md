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

# CodeAnywhere Workspace

[CodeAnywhere](https://codeanywhere.com) provides an excellent web based IDE with terminal. This should sufficient for our usage.

## Linux based host

- Setup kubectl

  ```
  curl -sLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod a+x kubectl
  sudo mv kubectl /usr/local/bin
  kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
  ```

- Setup pfs

  ```
  curl -sLO https://github.com/yogendra/pfs-workshop/raw/master/setup-environment/online-workspace/pfs.linux
  chmod a+x pfs.linux
  sudo mv pfs.linux /usr/local/bin/pfs
  pfs completion bash | sudo tee /etc/bash_completion.d/pfs > /dev/null

  ```

- Fetch Kuberentes config
  ```
  export WS_USER=user-01
  mkdir -p $HOME/.kube
  curl -sL https://github.com/yogendra/pfs-workshop/raw/master/setup-environment/users/$WS_USER/config -o $HOME/.kube/config
  ```

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

```

```

```

```
