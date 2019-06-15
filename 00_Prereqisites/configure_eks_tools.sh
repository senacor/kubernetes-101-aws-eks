#!/usr/bin/env bash

echo "Create the default ~/.kube directory for storing kubectl configuration"

mkdir -p ~/.kube >> install_tool.log

echo "Install kubectl"

sudo curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/kubectl >> install_tool.log

sudo chmod +x /usr/local/bin/kubectl >> install_tool.log

echo "Install AWS IAM Authenticator"

go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator >> install_tool.log
sudo mv ~/go/bin/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator >> install_tool.log

echo "Install JQ and envsubst"

sudo yum -y install jq gettext >> install_tool.log


echo "Verify the binaries are in the path and executable"

for command in kubectl aws-iam-authenticator jq envsubst
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done
