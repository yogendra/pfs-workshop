#!/usr/bin/env bash

image_prefix=gcr.io/pa-yrampuria

kubernetes_host=pfs-workshop-k8s.atwater.cf-app.com

kubernetes_ca=Ci0tLS0tQkVHSU4gQ0VSVElGSUNBVEUtLS0tLQpNSUlDK3pDQ0FlT2dBd0lCQWdJVVdwS1hIVGtwdWsvMyt1Rk51ZG1MQ3dET25hOHdEUVlKS29aSWh2Y05BUUVMCkJRQXdEVEVMTUFrR0ExVUVBeE1DWTJFd0hoY05NVGt3TmpFek1EYzFOVFE0V2hjTk1qTXdOakV6TURjMU5UUTQKV2pBTk1Rc3dDUVlEVlFRREV3SmpZVENDQVNJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dFUEFEQ0NBUW9DZ2dFQgpBTUtOMmg1SmY5ZHVKN0NwOWVhR1RBN3lPQmlLWE5UZ09ucmRMQWhDZ1pUKzY5dmRsN2M1b1UvcHp3eldVMmlkCno3YmUvVVo0ZGFqQWlPbXJGaFZUTWd4UUdvT0ExMUdlRlU2elAyTmFtNld4enEwb1ZMeXcyeHdnanFBK3lPa2IKLzJLWnRjVVVhdE8xM2VNeDdMb1BlRTZ5SnAzVWxCb0tYN3pGSERvZEtVMjJoUHQ3cEJVajdEdG1CcWtETmpWWQozaHo5Y0gwNzR2V1UxaUFDVkRKNGd3NUI4dVVhVkNNY2hsSnhjYnNFVkRMdW5qSngrT0RYbk94bWtGZUdJUFVnClB4d3gzQUlTUHJyWS9LdG1JOGg5bmxFUlZFdnJYZ0Y1eEhDWXp0UGV4ZzRsNW11U3h5bzdsM291MGpnb3d4ZGgKVUxVNTZNS0lmU2V2MFRxSERPRmlFeWtDQXdFQUFhTlRNRkV3SFFZRFZSME9CQllFRkFOWEh3MGJPWFBsYmNBNApFSWVSNmJiRDAzVS9NQjhHQTFVZEl3UVlNQmFBRkFOWEh3MGJPWFBsYmNBNEVJZVI2YmJEMDNVL01BOEdBMVVkCkV3RUIvd1FGTUFNQkFmOHdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSzNsMGY4czU2UWJLWG1nbENkUkpIL2MKVmZ0VDcxeTVkVzVlRnhHaFk4ZWJHaHMyYnFKTnk1VWlEd3J2cDllVUYwZXlybXNOOEk3cHBLSHVGbHUxcllRbApieU92Q0tkTXQvZGlMNytkRWxLZXppd2VBM0JxNjN1cEdOMVJiYnBmTE9TT3Bvd1NYTHA5RVE0bFlJQXBxSkVaCjV4UkJLc2Jyb1FZb1JSc0VoRHcwZTc2TVBheDJHY3pkdjh0Y1NWajV4SUJEbVNBblJtclRUK09iODY5aUhMSUUKWEJ0NnQ1WEVLdXdWTytaZC9zVlRxbkZ5cE1WaVJoMnBxTVZIc0ZISUhRa1NaaGQxRFVyeHBBKzhjNnVTdUJuNQoxb29kaEJFOXpFTjhHaER0b0gweW9Fcm1URXR5S3VZbEZPaytKQzV6b2VDeUIyVFhmTFVqSE1UdCtjOVpnK289Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K

users_start=01
users_end=99

managed_zone=atwater-zone


# ip=$(kubectl get service/istio-ingressgateway --namespace istio-system -o=json  | jq '.status.loadBalancer.ingress[0].ip' -r)
ip=34.67.190.62

# root_domain=$(kubectl get cm/config-domain --namespace knative-serving -o=json | jq '.data| keys[0]' -r)
root_domain=pfs.atwarer.cf-app.com


function for_all {
    op=$1;shift
    eval "echo {$users_start..$users_end}" | tr ' ' \\n | while read i 
    do
        i=$(printf "%02d" $i)
        $op $i
    done

}

function run {
    op=$1; shift
    if [[ $# -eq 0 ]] 
    then
        for_all $op $*
    else
        for i in $*
        do
            i=$(printf "%02d" $i)
            $op $i
        done
    fi    
}
