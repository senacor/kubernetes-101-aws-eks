# Kubernetes Basics

In this first excise we will ramp up an EKS cluster to get you up and
running.


## Step 1 - Validate IAM role

Validate that you use the correct IAM Role

    aws sts get-caller-identity
    
Like this it should contain the role summercamp2019_eks_101_workspaceadmin: 

    {
        "Account": "604370441254", 
        "UserId": "AROAYZN2JCQTO2KIV45L5:i-05b78cb6a06e83234", 
        "Arn": "arn:aws:sts::604370441254:assumed-role/summercamp2019_eks_101_workspaceadmin/i-05b78cb6a06e83234"
    }


## Step 2 - Ramp up EKS Cluster

You can setup you cluster with this command, please make sure to use you
individual shortname:

    
    eksctl create cluster --name=<shortname>-summercamp-eksctl --nodes=2 --node-ami=auto --region=${AWS_REGION} --tags CostCenter=ACDDEV_CENT

The cluster creation takes about 15 minutes. 

You can test your cluster with: 

    kubectl get nodes
 
This should return somthing like this. 

    NAME                                              STATUS   ROLES    AGE   VERSION
    ip-192-168-10-139.eu-central-1.compute.internal   Ready    <none>   40s   v1.12.7
    ip-192-168-75-186.eu-central-1.compute.internal   Ready    <none>   41s   v1.12.7

**Caution**: If the cluster creation stucks after 15 minutes after
storing the .kubconfig, you did not have set up the correct IAM richts
above. 

## Step 3 - Deploy the Kubernetes Dashboard

To the the cluster deployment ability you can not install the Kubernetes
Dashboard with. 

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
