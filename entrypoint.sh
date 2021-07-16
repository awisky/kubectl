#!/bin/sh

set -e

version="$1"
config="$2"
command="$3"

if [ "$version" = "latest" ]; then
  version=$(curl -Ls https://dl.k8s.io/release/stable.txt)
fi

echo "using kubectl@$version"

curl -sLO "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl" -o kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

echo "using aws-iam-authenticator"
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mv aws-iam-authenticator /usr/local/bin

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$config" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

sh -c "kubectl $command"
