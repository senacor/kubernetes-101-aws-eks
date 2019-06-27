#!/usr/bin/env bash

echo "-"
echo "--- Create the default ~/.kube directory for storing kubectl configuration"
echo "-"

mkdir -p ~/.kube >> install_tool.log

echo "-"
echo "--- Install kubectl"
echo "-"

sudo curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/kubectl >> install_tool.log

sudo chmod +x /usr/local/bin/kubectl >> install_tool.log

echo "-"
echo "--- Install kubectx (kubens)"
echo "-"

if [ ! -d /opt/kubectx ]; then
  sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx >> install_tool.log
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx >> install_tool.log
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens >> install_tool.log
fi

echo "-"
echo "--- Install AWS IAM Authenticator"
echo "-"

go get -u github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator >> install_tool.log
sudo mv ~/go/bin/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator >> install_tool.log

echo "-"
echo "--- Install JQ and envsubst"
echo "-"

sudo yum -y install jq gettext >> install_tool.log

echo "-"
echo "--- Download eksctl bins"
echo "-"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

sudo mv -v /tmp/eksctl /usr/local/bin

echo "-"
echo "--- Verify the binaries are in the path and executable"
echo "-"

for command in kubectl aws-iam-authenticator jq envsubst
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done
