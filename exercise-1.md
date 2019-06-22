# Simple Function

**Duration: 30 min**

In this exercise we will do some simple method creation, upd ate, invoke and delete it. We will use a simple shell script as our backend processing engine in this exercise.

## Create a function

First we create a function.

```
pfs function create wordcount --git-repo https://github.com/yogendra/pfs-command-wordcount --artifact wordcount.sh
```

> _Tip_: you can fork the sample repo and swap out the name. This way you do not need to wait for instructor

You should see an out put similar to following

```
Applied default --image="gcr.io/pa-yrampuria/default/wordcount"

pfs function create completed successfully
Issue `pfs service status wordcount` to see the status of the function
```

Lets `watch` the output of `pfs service status` command

Until the function is created, you will see the output as follows:

```
Last Transition Time:        2019-06-22T16:28:04Z
Message:                     Configuration "wordcount" is waiting for a Revision to become ready.
Reason:                      RevisionMissing
Status:                      Unknown
Type:                        Ready
```

One the function is created successfully, you will see following output.

```
Last Transition Time:        2019-06-22T16:28:50Z
Status:                      True
Type:                        Ready

```

## Invoke a function

Lets invoke out function using `pfs` tool first.

```
pfs service  invoke --text wordcount -- --data "this is a simple text to get count of words in a sentence"
```

Let's invoke this one more time with lots of data. Lets see which word appears most in the US Contitution

```
curl -s https://www.usconstitution.net/const.txt | pfs service invoke wordcount  --text -- -d  @-
```

## Whats under the hood?

Functio creationm creates several kubernettes objects in your namespace. Lets examine them briefly before proceeding.

```
kubectl get all
```

You should see output as follows

```
NAME                             READY   STATUS      RESTARTS   AGE
pod/wordcount-dkds4-pod-8addcc   0/1     Completed   0          6m58s

NAME                              TYPE           CLUSTER-IP      EXTERNAL-IP                                           PORT(S)           AGE
service/kubernetes                ClusterIP      10.100.200.1    <none>                                                443/TCP           10h
service/wordcount                 ExternalName   <none>          istio-ingressgateway.istio-system.svc.cluster.local   <none>            6m12s
service/wordcount-8wgdr-service   ClusterIP      10.100.200.91   <none>                                                80/TCP,9090/TCP   6m21s

NAME                                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/wordcount-8wgdr-deployment   0/0     0            0           6m21s

NAME                                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/wordcount-8wgdr-deployment-58cdf8cdb5   0         0         0       6m21s

NAME                                                             READY   REASON
podautoscaler.autoscaling.internal.knative.dev/wordcount-8wgdr   False   NoTraffic

NAME                                      SUCCEEDED   REASON   STARTTIME   COMPLETIONTIME
build.build.knative.dev/wordcount-dkds4   True                 6m

NAME                                              AGE
clusterbuildtemplate.build.knative.dev/riff-cnb   9m

NAME                                                       AGE
image.caching.internal.knative.dev/wordcount-8wgdr-cache   6m

NAME                                                               READY   REASON
clusterchannelprovisioner.eventing.knative.dev/in-memory           True
clusterchannelprovisioner.eventing.knative.dev/in-memory-channel   True

NAME                                                                                        READY   REASON
clusteringress.networking.internal.knative.dev/route-b5ffe8eb-950a-11e9-a0e0-42010a000b0a   True

NAME                                    DOMAIN                          LATESTCREATED     LATESTREADY       READY   REASON
service.serving.knative.dev/wordcount   wordcount.default.example.com   wordcount-8wgdr   wordcount-8wgdr   True

NAME                                  DOMAIN                          READY   REASON
route.serving.knative.dev/wordcount   wordcount.default.example.com   True

NAME                                          LATESTCREATED     LATESTREADY       READY   REASON
configuration.serving.knative.dev/wordcount   wordcount-8wgdr   wordcount-8wgdr   True

NAME                                           SERVICE NAME              GENERATION   READY   REASON
revision.serving.knative.dev/wordcount-8wgdr   wordcount-8wgdr-service   1            True
```

## Update a function

Let make a change to our functio. Wait for the instructor to make the change.
Ones the change is done by the instructor

## Delete a function
