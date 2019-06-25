# Exercise 2 : Java Script and Java Based Function

[Previous Exercise](exercise-1.md) | [Back to Main](README.md) | [Cheatsheet](cheatsheet.md)

**Duration: 30 min**
We have so far created function with simple shell script. Lets create function using JS and Java langauge now.

## Function with JavaScript

We will create a simple function to square a number. Git repo for this function is [yogendra/pfs-node-square](https://github.com/yogendra/pfs-node-square.git).

```
> pfs function create square  --git-repo https://github.com/yogendra/pfs-node-square.git --artifact square.js --verbose
```

Ones creation is successful, let's invoke the `square` function.

```
> curl http://square.default.example.com' -H 'Content-Type: application/json' -w '\n' -d 7
```

**Change URL to match the service url**

## Function with Java

Next we will create a function with Java. Git repo for this function is [yogendra/pfs-java-function-invoker](https://github.com/yogendra/pfs-java-function-invoker.git)

```
> pfs function create greeter  --git-repo https://github.com/yogendra/pfs-java-function-invoker.git --sub-path samples/greeter --verbose
```

As usual, lets invoke our service

```
> curl 'http://greeter.default.example.com' -H 'Content-Type: text/plain' -w '\n' -d "Yogi"
```

[Previous](exercise-1.md) | [Back to Main](README.md) | [Cheatsheet](cheatsheet.md)
