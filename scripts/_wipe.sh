#!/bin/sh

echo "\n 1. Deleting minikube cluster \n"
minikube delete --all

echo "\n 2. (Optional) Delete the Github SSH Key private (GITHUB_SSH_KEY_FILE) \n"

echo "\n 3. If necessary, delete the Github SSH Key public \n"

echo "\n Finished! \n"
