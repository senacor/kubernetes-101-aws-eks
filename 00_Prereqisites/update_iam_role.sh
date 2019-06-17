#!/usr/bin/env bash

echo "-"
echo "--- remove old credentials folder"
echo "-"
rm -vf ${HOME}/.aws/credentials

echo "-"
echo "--- export Account and region"
echo "-"
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')

echo "export ACCOUNT_ID=${ACCOUNT_ID}" >> ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" >> ~/.bash_profile
aws configure set default.region ${AWS_REGION}
aws configure get default.region
