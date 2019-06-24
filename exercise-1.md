# Exercise - 1 : Simple Function

**Duration: 30 min**

In this exercise we will do some simple method creation, upd ate, invoke and delete it. We will use a simple shell script as our backend processing engine in this exercise.

## Create a function

First we create a function.

```
> pfs function create wordcount --git-repo https://github.com/yogendra/pfs-command-wordcount.git --artifact wordcount.sh
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
> pfs service  invoke --text wordcount -- --data "this is a simple text to get count of words in a sentence"
```

Let's invoke this one more time with lots of data. Lets see which word appears most in the US Contitution

```
> curl -s https://www.usconstitution.net/const.txt | pfs service invoke wordcount  --text -- -d  @-
```

How about invoking this via url? Thats easy! Every service gets its own route. Route will look like `<service-name>.<namespace>.example.com`. So this `wordcount` service can be invoked via:

```
> curl -s http://wordcount.default.pfs.atwater.cf-app.com --data "this is a simple text to get count of words in a sentence"
      1 count
      1 get
      1 in
      1 is
      1 of
      1 sentence
      1 simple
      1 text
      1 this
      1 to
      1 words
      2 a
```

You will need to replace `default` with your own namespace.

## Whats under the hood?

Functio creationm creates several kubernettes objects in your namespace. Lets examine them briefly before proceeding.

```
> kubectl get all
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

> _Note:_ Wait for the instructor to make the change befor proceeding

Lets change the code to skip some words (a, of in, is & to). After making a simple change, run `function update` command to pickup changes

```
> pfs function update wordcount --verbose
```

This time we used `verbose` flag to see the progress. You will see that in the output `builder` and `invokers` are detected automatically. Since we are using a shell script, **Command Function Buildpack** is selected and **Command Invoker** is used for running our function

```
Waiting for LatestCreatedRevisionName
LatestCreatedRevisionName available: wordcount-cfv7j
Waiting on function creation: function creation incomplete: service status unknown:
default/wordcount-cbfhc-pod-7f1fdc[build-step-credential-initializer]: {"level":"info","ts":1561232190.5124333,"logger":"fallback-logger","caller":"creds-init/main.go:40","msg":"Credentials initialized.","commit":"4fc8663"}
default/wordcount-cbfhc-pod-7f1fdc[build-step-git-source-0]: {"level":"info","ts":1561232196.1769645,"logger":"fallback-logger","caller":"git-init/main.go:101","msg":"Successfully cloned \"https://github.com/yogendra/pfs-command-wordcount.git\" @ \"master\" in path \"/workspace\"","commit":"4fc8663"}
default/wordcount-cbfhc-pod-7f1fdc[build-step-analyze]: removing stale cached launch layer 'io.projectriff.command:riff-invoker-command'
default/wordcount-cbfhc-pod-7f1fdc[build-step-analyze]: removing stale cached launch layer 'io.projectriff.command:function'
default/wordcount-cbfhc-pod-7f1fdc[build-step-analyze]: using cached layer 'io.projectriff.command:launch'
default/wordcount-cbfhc-pod-7f1fdc[build-step-analyze]: writing metadata for uncached layer 'io.projectriff.command:function'
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]: -----> Command Function Buildpack 0.0.8
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]: -----> riff Command Invoker 0.0.8: Contributing to layer
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]:        Reusing cached download from buildpack
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]:        Expanding /buildpacks/io.projectriff.command/0.0.8/dependency-cache/cf475eae3043cf7dc0818b5ccd70f99c9542d798160fa3965c8506787a70e8d3/command-function-invoker-linux-amd64-0.0.8.tgz to /layers/io.projectriff.command/riff-invoker-command
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]: -----> Command wordcount.sh: Reusing cached layer
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]: -----> Process types:
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]:        web:      /layers/io.projectriff.command/riff-invoker-command/command-function-invoker
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]:        function: /layers/io.projectriff.command/riff-invoker-command/command-function-invoker
default/wordcount-cbfhc-pod-7f1fdc[build-step-build]:
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: adding layer 'app' with diffID 'sha256:6d7309f465aa42d84e5d7db3c55ed05e68410cebed390c5085ffe3346636553c'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: reusing layer 'config' with diffID 'sha256:2445f1e863266a22e3bff37d79b38277c76746e70e5348e7644bc5099ef27ad3'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: reusing layer 'launcher' with diffID 'sha256:7417c05f2e27d60b777911b95a538f0bac23fec8fec4175a499039949781fabc'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: reusing layer 'io.projectriff.command:riff-invoker-command' with diffID 'sha256:6107b1e71e79c80fc6d8154590887e072dbed2f7fc9c1d784dfed16ae15b6f6c'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: reusing layer 'io.projectriff.command:function' with diffID 'sha256:d6546cae64e8f674950ae9b5b855ef224afbdef820160667ed13464befaef04b'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: setting metadata label 'io.buildpacks.lifecycle.metadata'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: setting env var 'CNB_LAYERS_DIR=/layers'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: setting env var 'CNB_APP_DIR=/workspace'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: setting entrypoint '/lifecycle/launcher'
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: setting empty cmd
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: writing image
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]:
default/wordcount-cbfhc-pod-7f1fdc[build-step-export]: *** Image: gcr.io/pa-yrampuria/default/wordcount@sha256:4bae882cae9bb007f16e26d9aafbcda4bcd04b63607f81e3e5bcfed2a147df94

pfs function update completed successfully
```

Unlike `create` invocatione this command has waited for the function to be deployed fully. This is added be the `--verbose` flag.

Ones the commands finished successfully, lets invoke this again.

```
> curl -s http://wordcount.default.pfs.atwater.cf-app.com --data "this is a simple text to get count of words in a sentence"

      1 count
      1 get
      1 sentence
      1 simple
      1 text
      1 this
      1 words
```

Voila! this time we don't see the skipped words in the output.

## Delete a function

Final part of this exercise is to remove a function. This is very simple. You just need to invoke `service delete`

```
> pfs service delete wordcount

pfs service delete completed successfully

```

That's it.

You can verify deletion by running `service list` command

```
> pfs service list

No resources found

pfs service list completed successfully
```

## Extra Credits

Try creating function from node js app. There is a sample at `https://github.com/yogendra/pfs-node-square.git"
