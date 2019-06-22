#!/usr/bin/env bash
echo {01..99} | tr ' ' \\n | while read i 
do

user=user-$i
namespace=${user}-ns

user_root=users/$user
config_file=$user_root/config

# Create user
# Create namespace


user_name=$user

kubectl create ns ${namespace}
kubectl create sa ${user_name} -n ${namespace}
kubectl create rolebinding ${user_name}-rb --clusterrole=admin --serviceaccount=${namespace}:${user_name} -n ${namespace}
kubectl create rolebinding ${user_name}-rb --clusterrole=admin --serviceaccount=${namespace}:${user_name} -n default
user_token=$(kubectl get secret $(kubectl get sa $user_name -n ${namespace} -o json | jq -r .secrets[0].name) -n ${namespace} -o json | jq -r .data.token | base64 -D)

mkdir -p $user_root
cat <<EOF > $config_file
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: Ci0tLS0tQkVHSU4gQ0VSVElGSUNBVEUtLS0tLQpNSUlDK3pDQ0FlT2dBd0lCQWdJVVdwS1hIVGtwdWsvMyt1Rk51ZG1MQ3dET25hOHdEUVlKS29aSWh2Y05BUUVMCkJRQXdEVEVMTUFrR0ExVUVBeE1DWTJFd0hoY05NVGt3TmpFek1EYzFOVFE0V2hjTk1qTXdOakV6TURjMU5UUTQKV2pBTk1Rc3dDUVlEVlFRREV3SmpZVENDQVNJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dFUEFEQ0NBUW9DZ2dFQgpBTUtOMmg1SmY5ZHVKN0NwOWVhR1RBN3lPQmlLWE5UZ09ucmRMQWhDZ1pUKzY5dmRsN2M1b1UvcHp3eldVMmlkCno3YmUvVVo0ZGFqQWlPbXJGaFZUTWd4UUdvT0ExMUdlRlU2elAyTmFtNld4enEwb1ZMeXcyeHdnanFBK3lPa2IKLzJLWnRjVVVhdE8xM2VNeDdMb1BlRTZ5SnAzVWxCb0tYN3pGSERvZEtVMjJoUHQ3cEJVajdEdG1CcWtETmpWWQozaHo5Y0gwNzR2V1UxaUFDVkRKNGd3NUI4dVVhVkNNY2hsSnhjYnNFVkRMdW5qSngrT0RYbk94bWtGZUdJUFVnClB4d3gzQUlTUHJyWS9LdG1JOGg5bmxFUlZFdnJYZ0Y1eEhDWXp0UGV4ZzRsNW11U3h5bzdsM291MGpnb3d4ZGgKVUxVNTZNS0lmU2V2MFRxSERPRmlFeWtDQXdFQUFhTlRNRkV3SFFZRFZSME9CQllFRkFOWEh3MGJPWFBsYmNBNApFSWVSNmJiRDAzVS9NQjhHQTFVZEl3UVlNQmFBRkFOWEh3MGJPWFBsYmNBNEVJZVI2YmJEMDNVL01BOEdBMVVkCkV3RUIvd1FGTUFNQkFmOHdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSzNsMGY4czU2UWJLWG1nbENkUkpIL2MKVmZ0VDcxeTVkVzVlRnhHaFk4ZWJHaHMyYnFKTnk1VWlEd3J2cDllVUYwZXlybXNOOEk3cHBLSHVGbHUxcllRbApieU92Q0tkTXQvZGlMNytkRWxLZXppd2VBM0JxNjN1cEdOMVJiYnBmTE9TT3Bvd1NYTHA5RVE0bFlJQXBxSkVaCjV4UkJLc2Jyb1FZb1JSc0VoRHcwZTc2TVBheDJHY3pkdjh0Y1NWajV4SUJEbVNBblJtclRUK09iODY5aUhMSUUKWEJ0NnQ1WEVLdXdWTytaZC9zVlRxbkZ5cE1WaVJoMnBxTVZIc0ZISUhRa1NaaGQxRFVyeHBBKzhjNnVTdUJuNQoxb29kaEJFOXpFTjhHaER0b0gweW9Fcm1URXR5S3VZbEZPaytKQzV6b2VDeUIyVFhmTFVqSE1UdCtjOVpnK289Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://pfs-workshop-k8s.atwater.cf-app.com:8443
  name: workshopt-cluster
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
pfs --kubeconfig $config_file namespae init --image-prefix gcr.io/pa-yrampuria/pfs-workshop/$namespace 

echo Finished creating user:$user ns:$namespace and config:$config_file
done


