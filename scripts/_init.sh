#!/bin/sh

set -e

GITHUB_EMAIL="ken.mkina@gmail.com"
GITHUB_SSH_KEY_PASSPHRASE="PASSPHRASE"
GITHUB_SSH_KEY_FILE="$HOME/.ssh/devops-jenkins/id_ed25519"

DOCKER_CONFIG_FILE="$HOME/.docker/config.json"

MINIKUBE_CONFIG_FILE="$HOME/.kube/config"

JENKINS_NAMESPACE="devops-jenkins"
JENKINS_HOST_PORT="8080"

### main

echo "\n 0. Checking requeriments \n"
. ./scripts/check-min-requirements.sh

echo "\n 1. Starting Minikube... \n"
minikube start --cpus=8 --memory=6000m
minikube addons enable ingress

echo "\n 2. Installing Jenkins... \n"

echo "\n 2.1. Configuring kubernetes resources... \n"
kubectl apply -f kubernetes/

echo "\n 2.2. Creating kubernetes secrets... \n"
. ./scripts/create-secrets-on-minikube.sh

echo "\n 2.3. Creating Jenkins resources on Minikube... \n"
helm upgrade jenkins jenkins/jenkins \
    --version 4.3.20 \
    --namespace $JENKINS_NAMESPACE \
    --wait \
    --install \
    --values helm/values.yaml \
    --values helm/values.custom.yaml \
    --values helm/values.system.yaml \
    --values helm/values.security.yaml \
    --values helm/values.jobs.seed.yaml

echo "\n 3. Retrieving Jenkins admin credentials... \n"
JENKINS_PASSWORD=$(
    kubectl exec -it svc/jenkins \
        --namespace $JENKINS_NAMESPACE \
        -c jenkins \
        -- /bin/cat /run/secrets/additional/chart-admin-password
)

echo "\n Jenkins admin credentials ( admin : $JENKINS_PASSWORD ) \n"

echo "\n 4. Retrieving Jenkins address from Ingress. It might take some time... \n"

#kubectl port-forward svc/jenkins 8080:$JENKINS_HOST_PORT \
#    --namespace $JENKINS_NAMESPACE

kubectl get ingress jenkins \
    --namespace $JENKINS_NAMESPACE

until kubectl get ingress jenkins \
    --namespace $JENKINS_NAMESPACE \
    --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do :; done

K8S_INGRESS_IP=$(kubectl get ingress jenkins \
    --namespace $JENKINS_NAMESPACE \
    --output=jsonpath='{.status.loadBalancer.ingress[].ip}')

echo "\n Jenkins: http://$K8S_INGRESS_IP/jenkins"
