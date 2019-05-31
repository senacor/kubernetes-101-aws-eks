# Kubernetes Basics

This exercise is about mastering the kubernetes (k8s) command line tool `kubectl` and the k8s configuration files.

You will use the *sock shop* application as exercise and deploy it to k8s, first in a basic setup and later extend it with more advanced k8s features.

## Step 1 - Getting Started

In this first step, you will make sure that your tools are properly setup, create a playground for you to work in in an existing cluster, and deploy the first part of the sock shop application to k8s.

Create a namespace for you as playgroud like this:

```
kubectl create ns your-name
```

Make that your default namespace

```
kubens your-name
```

Deploy the provided example files for the first part of the sock shop, the front-end:

```
kubectl apply -f front-end-deployment.yaml 
kubectl apply -f front-end-service.yam
```

Get the status of the deployed application

```
kubectl get pods
```

It should show this:

```
kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
front-end-7bf4897479-2bsfc   1/1     Running   0          53s
```

Next check the exposed port of the application

```
kubectl get service
```

It should show this:

```
NAME        TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
front-end   LoadBalancer   10.103.254.55   12.34.56.78   80:32246/TCP   18m
```

Now navigate to the web interface exposed port 80 and the IP shown below EXTERNAL-IP in a web browser with http (not https). You shoud see the web interface of the sock-shop, but without any items as the socks database is missing. You will add these missing parts in the next steps.

### Already Done?

To explore some more, check out this page and try out more advanced commands: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

## Step 2 - Add the catalogue service and its database

Next you will learn how to write k8s config files for two additional components.

### Catalogue DB

The catalogue db is a database for the sock-shop catalogue backend and needs to be configured like this:

In the Deployment file:
* declare docker image: `weaveworksdemos/catalogue-db:0.3.0`
* declare 3 environment variables:
```
MYSQL_ALLOW_EMPTY_PASSWORD="true"
MYSQL_DATABASE=socksdb
MYSQL_ROOT_PASSWORD=
```
* expose port 3306 from the container

In the Service file:
* expose port 3306 from the deployment
* make sure the service is named `catalogue-db`

Now create a Deployment and Service for above settings. To get started, have a look at the existing k8s config yaml files for front-end,
copy them and adapt them as required.

Next deploy the database with `kubectl` by applying the created configuration files. This should create a new pod which should start without errors.

### Catalogue

Catalogue is a service which is used by the front-end to access its catalogue of socks. 

In the Deployment file:
* declare docker image: `weaveworksdemos/catalogue:0.3.5`
* exposes port 80 from the container

In the Service file:
* expose port 80 from the deployment
* make sure the service is named `catalogue`

Now create a Deployment and Service for above settings and again apply the created configuration files. Check that the pod started without errors. 

Reload the front-end web page, it should show a nice list of sock offerings. If not, check below section **Error Hunting** for hints 

### More Information

For more information on services and deployments, have a look at this k8s documentation:

* https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
* https://kubernetes.io/docs/concepts/services-networking/service/

### Error Hunting

If things do not go as smooth, you can use the following commands to go error hunting.

To get a log of a pod, use:

```
kubectl log pod-name 
```

To open up a shell in a pod, to check things from inside, use:

```
kubectl exec -it pod-name sh
```

## Step 3 - Add lifeness and readiness probes

1. Update the deployments to contain valid probes for the font-end as well as the catalogue service.
2. Redeploy
3. Check that all pods come up in status "READY 1/1". This will take longer, depending on your settings on the probes. 

See https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/ for reference. 

For testing, you can access your pods to find out ports etc like this:

```
$ kubectl get pods
NAME                            READY     STATUS    RESTARTS   AGE
catalogue-67f85bd666-28zll      1/1       Running   0          13m
catalogue-db-5cc5c5b4b6-s8lkn   1/1       Running   0          13m
front-end-74464645d-mfwh7       1/1       Running   0          5m

$ kubectl exec -it catalogue-67f85bd666-28zll sh

/ $ wget http://localhost:80/health -O-

Connecting to localhost:80 (127.0.0.1:80)
{"health":[{"service":"catalogue","status":"OK","time":"2018-11-08 16:36:36.336317212 +0000 UTC"},{"service":"catalogue-db","status":"OK","time":"2018-11-08 16:36:36.336541455 +0000 UTC"}]}
-                    100% |*******************************|   190   0:00:00 ETA
```

## Step 4 - Scale the services for more power

1. Scale up the front-end and catalogue deployment to 2 replicas. Do you know why you shouldn't scale up catalogue-db?
2. Next create a *ping* script to check that your service is alive.
You can use a script like the one shown below, but replace the example ip 12.34.56.78 with the EXTERNAL-IP: 

```
while true; do curl -s -o /dev/null -w "%{http_code}\n" http://12.34.56.78:80; sleep 1; done`
```

Or if you like write a small gatling script and I will add it in future trainings ;-)

Now kill one pod by executing `kubectl delete pod pod-name` and see what happens. If your probe works correctly, there should be NO failure. 

## Optional Step 5

Create a volume for the catalogue-db deployment to provide it with a persistent storage. 

For more info see Kubernetes documents on volumes: https://kubernetes.io/docs/concepts/storage/volumes/

