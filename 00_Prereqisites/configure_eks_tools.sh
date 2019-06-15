#!/usr/bin/env bash

echo "Create the default ~/.kube directory for storing kubectl configuration"

mkdir -p ~/.kube

echo "Install kubectl"

sudo curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/kubectl

sudo chmod +x /usr/local/bin/kubectl

echo "Install AWS IAM Authenticator"

go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator
sudo mv ~/go/bin/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

echo "Install JQ and envsubst"

sudo yum -y install jq gettext


echo "Verify the binaries are in the path and executable"

for command in kubectl aws-iam-authenticator jq envsubst
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done
