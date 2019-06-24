# Exercise 2 : Channels and Subscriptions

**Duration: 30 min**

So far we have only invoked our functions directly using `pfs servuce invoke` or `curl`. This is a direct invocation and caused a hard coupleing between consumer and service. Modern workloads almost mandates having flexible integration. This is where channels and subscription come in.

![Channels and Subscription](images/eventing-concept.png)


Channels are essentially like 'conduits' or 'pipes' carrying data. Subscription is a mechanism to extract or connect that stream of data to a service. 


Let use examine this in action


## Create a channel


