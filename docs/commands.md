<br />
<div align="center">
  <h1 align="center">Jenkins on Minikube</h1>
</div>



## SH commands

```sh
# Installation
sh scripts/_init.sh

# Uninstallation
sh scripts/_wipe_.sh


# Start, stop or delete Minikube
minikube start --cpus=8 --memory=6000m
minikube dashboard --url

minikube stop
minikube delete --all


# Kill kubectl process like `kubectl port-forward`
killall kubectl


# Create Jenkins namespace
kubectl create ns devops-jenkins


# Build Jenkins image
TAG="kenkina/jenkins-on-minikube:2.387.2-lts-jdk17" && \
  docker build -t $TAG -f image/Dockerfile . && \
  docker push $TAG


# Build Maven agent image (maven3_java17)
TAG="kenkina/jenkins-inbound-maven-agent:3107.v665000b_51092-5-alpine-jdk17" && \
  docker build -t $TAG -f agents/maven3_java17/Dockerfile . && \
  docker push $TAG


# Install Jenkins

helm repo add jenkins https://charts.jenkins.io
helm repo update

helm show values jenkins/jenkins \
  --version 4.3.20 > helm/values.yaml

helm get values -n devops-jenkins jenkins

# Default installation
helm install jenkins jenkins/jenkins \
  --version 4.3.20 \
  -n devops-jenkins \
  --create-namespace

# Custom installation
helm install jenkins jenkins/jenkins \
  --version 4.3.20 \
  -n devops-jenkins \
  --create-namespace \
  -f helm/values.yaml

# Custom installation
kubectl apply -f kubernetes && \
  helm upgrade jenkins jenkins/jenkins \
  --version 4.3.20 \
  -n devops-jenkins \
  --wait --install \
  -f helm/values.yaml \
  -f helm/values.custom.yaml \
  -f helm/values.system.yaml \
  -f helm/values.security.yaml \
  -f helm/values.jobs.seed.yaml && \
  echo -e "\n Jenkins credentials ( admin : $(kubectl exec -n devops-jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password) ) \n" && \
  kubectl -n devops-jenkins port-forward svc/jenkins 8080:8080

#--dry-run --debug > helm/revisions/revision.4.3.20.txt


helm uninstall jenkins -n devops-jenkins && \
  kubectl delete pv --all && \
  kubectl delete ns jenkins


# Get Jenkins admin password
kubectl exec -it svc/jenkins \
  -n devops-jenkins \
  -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && \
  echo


# Expose Jenkins
kubectl exec -it svc/jenkins \
  -n devops-jenkins \
  -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && \
  echo && \
  kubectl -n devops-jenkins port-forward svc/jenkins 8080:8080

> Sample credentials:
> - user: admin
> - password: fkG8DWYSaOdjffjUKwB0Uo


# Execute commands in pod
kubectl exec -n devops-jenkins -it svc/jenkins -c jenkins -- /bin/sh


# Execute kubectl
docker run --rm \
  --name kubectl \
  -v $HOME/.kube/config:/.kube/config \
  bitnami/kubectl:latest version


# String format with `date` and `BUILD_ID`
BUILD_ID=2
dateformat=$(date --utc +"%Y%m%d.%H%M.$BUILD_ID")
echo $dateformat

```


## Groovy commands

```groovy
// Get all Jenkins plugins

def pluginList = new ArrayList(Jenkins.instance.pluginManager.plugins)
pluginList.sort { it.getShortName() }.each{
  plugin -> 
    println ("${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}")
}

def pluginList = new ArrayList(Jenkins.instance.pluginManager.plugins)
pluginList.sort { it.getShortName() }.each{
  plugin -> 
    println ("${plugin.getShortName()}:${plugin.getVersion()}")
}


// Decrypt values

println(hudson.util.Secret.decrypt("{XXX}"))


// Execute commands

def sout = new StringBuilder(), serr = new StringBuilder()
def proc = 'ls -lah'.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)
println "out> $sout\nerr> $serr"

```
