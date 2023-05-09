#!/bin/sh

set -e

MINIKUBE_CONFIG_TMP_FILE_PATH=/tmp/.kube
MINIKUBE_CONFIG_TMP_FILE=$MINIKUBE_CONFIG_TMP_FILE_PATH/config

mkdir -p $MINIKUBE_CONFIG_TMP_FILE_PATH
cp $MINIKUBE_CONFIG_FILE $MINIKUBE_CONFIG_TMP_FILE

sed -i "s|certificate-authority:|certificate-authority-data:|g" $MINIKUBE_CONFIG_TMP_FILE
sed -i "s|client-certificate:|client-certificate-data:|g" $MINIKUBE_CONFIG_TMP_FILE
sed -i "s|client-key:|client-key-data:|g" $MINIKUBE_CONFIG_TMP_FILE

CA_CERT=$(
    cat $HOME/.minikube/ca.crt | base64 -w 0
    echo
)

CLIENT_CERT=$(
    cat $HOME/.minikube/profiles/minikube/client.crt | base64 -w 0
    echo
)

CLIENT_KEY=$(
    cat $HOME/.minikube/profiles/minikube/client.key | base64 -w 0
    echo
)

sed -i "s|$HOME/.minikube/ca.crt|$CA_CERT|g" $MINIKUBE_CONFIG_TMP_FILE
sed -i "s|$HOME/.minikube/profiles/minikube/client.crt|$CLIENT_CERT|g" $MINIKUBE_CONFIG_TMP_FILE
sed -i "s|$HOME/.minikube/profiles/minikube/client.key|$CLIENT_KEY|g" $MINIKUBE_CONFIG_TMP_FILE

chmod -R 644 $MINIKUBE_CONFIG_TMP_FILE

echo "\n 2.2.3.1. Validating KUBE_CONFIG file... \n"

docker run \
    --rm \
    --name kubectl \
    -v $MINIKUBE_CONFIG_TMP_FILE:/.kube/config \
    --network minikube \
    bitnami/kubectl:latest get pods -A
