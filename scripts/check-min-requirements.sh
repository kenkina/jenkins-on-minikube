#!/bin/sh

set -e

# Compare two versions and return 0 if the second version is greater than or equal to the first version.
#
# Parameters:
# $1: The first version. Installed version
# $2: The second version. Minimun required version
version_greater_equal() {
    printf '%s\n%s\n' "$2" "$1" | sort --check=quiet --version-sort
}

# Set the required versions for each software dependency
MIN_UBUNTU_VERSION="22.04"
MIN_DOCKER_VERSION="23.0.4"
MIN_KUBECTL_VERSION="v1.27.1"
MIN_MINIKUBE_VERSION="v1.30.1"
MIN_HELM_VERSION="v3.11.3"

# Check ubuntu version

if [ "$(lsb_release -is)" = "Ubuntu" ] && CURRENT_UBUNTU_VERSION=$(lsb_release -sr); then
    if version_greater_equal "$CURRENT_UBUNTU_VERSION" "$MIN_UBUNTU_VERSION"; then
        echo "ubuntu version is supported: ($CURRENT_UBUNTU_VERSION >= $MIN_UBUNTU_VERSION)"
    else
        echo "Error: ubuntu version $MIN_UBUNTU_VERSION or higher is required"
        exit 1
    fi
else
    echo "Error: This OS is not ubuntu"
    exit 1
fi

# Check docker version
if CURRENT_DOCKER_VERSION=$(docker version --format '{{.Server.Version}}'); then
    if version_greater_equal "$CURRENT_DOCKER_VERSION" "$MIN_DOCKER_VERSION"; then
        echo "docker version is supported: ($CURRENT_DOCKER_VERSION >= $MIN_DOCKER_VERSION)"
    else
        echo "Error: docker version $MIN_DOCKER_VERSION or higher is required"
        exit 1
    fi
else
    echo "Error: docker is not installed or not running"
    exit 1
fi

# Check docker config
if [ -e "$DOCKER_CONFIG_FILE" ] && [ -s "$DOCKER_CONFIG_FILE" ]; then
    echo "docker config exists ($DOCKER_CONFIG_FILE)"
else
    echo "Error: docker config does not exist or is empty (try to login with \`docker login\`)"
    exit 1
fi

# Check kubectl version
if CURRENT_KUBECTL_VERSION=$(kubectl version -oyaml --client | awk '/gitVersion/{print $2;}'); then
    if version_greater_equal "$CURRENT_KUBECTL_VERSION" "$MIN_KUBECTL_VERSION"; then
        echo "kubectl version is supported: ($CURRENT_KUBECTL_VERSION >= $MIN_KUBECTL_VERSION)"
    else
        echo "Error: kubectl version $MIN_KUBECTL_VERSION or higher is required"
        exit 1
    fi
else
    echo "Error: kubectl is not installed or not running"
    exit 1
fi

# Check minikube version
if CURRENT_MINIKUBE_VERSION=$(minikube version --short); then
    if version_greater_equal "$CURRENT_MINIKUBE_VERSION" "$MIN_MINIKUBE_VERSION"; then
        echo "minikube version is supported: ($CURRENT_MINIKUBE_VERSION >= $MIN_MINIKUBE_VERSION)"
    else
        echo "Error: minikube version $MIN_MINIKUBE_VERSION or higher is required"
        exit 1
    fi
else
    echo "Error: minikube is not installed or not running"
    exit 1
fi

# Check helm version
if CURRENT_HELM_VERSION=$(helm version --short); then
    if version_greater_equal "$CURRENT_HELM_VERSION" "$MIN_HELM_VERSION"; then
        echo "helm version is supported: ($CURRENT_HELM_VERSION >= $MIN_HELM_VERSION)"
    else
        echo "Error: helm version $MIN_HELM_VERSION or higher is required"
        exit 1
    fi
else
    echo "Error: helm is not installed or not running"
    exit 1
fi

echo "\n All dependencies are installed and OK. \n"
