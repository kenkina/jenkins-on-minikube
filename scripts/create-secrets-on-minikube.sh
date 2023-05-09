#!/bin/sh

set -e

echo "\n 2.2.1 Creating secret to connect with Github (SSH key) ... \n"

. ./scripts/config-github-ssh-key.sh

echo "\n 2.2.2 Creating secret from Docker config ($DOCKER_CONFIG_FILE)... \n"

kubectl delete secret regcred \
    --namespace $JENKINS_NAMESPACE \
    --ignore-not-found

kubectl create secret generic regcred \
    --namespace $JENKINS_NAMESPACE \
    --from-file=.dockerconfigjson=$DOCKER_CONFIG_FILE \
    --type=kubernetes.io/dockerconfigjson

echo "\n 2.2.3. Configuring KUBE_CONFIG file... \n"

. ./scripts/config-minikube-config.sh

kubectl delete secret secret-jenkins \
    --namespace $JENKINS_NAMESPACE \
    --ignore-not-found

kubectl create secret generic secret-jenkins \
    --namespace $JENKINS_NAMESPACE \
    --from-literal=demo=demo \
    --from-file=github-ssh-key-private=$GITHUB_SSH_KEY_FILE \
    --from-literal=github-ssh-key-passphrase=$GITHUB_SSH_KEY_PASSPHRASE \
    --from-file=kube-config=$MINIKUBE_CONFIG_TMP_FILE
