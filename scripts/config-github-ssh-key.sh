#!/bin/sh

set -e

# Check if Github SSH Key exists
if [ -e "$GITHUB_SSH_KEY_FILE" ] && [ -s "$GITHUB_SSH_KEY_FILE" ]; then
    while true; do
        echo "\n Github SSH Key file exists in ($GITHUB_SSH_KEY_FILE) \n"
        read -p "* IMPORTANT: Jenkins will use your existintg SSH key to connect to Github. Is it OK? (y/n) " answer
        case $answer in
        [Yy]*)
            echo "Continuing..."
            break
            ;;
        [Nn]*)
            echo "Exiting..."
            exit
            ;;
        *) echo "Please, answer y or n." ;;
        esac
    done
else
    echo "\n Github SSH Key file does NOT exist in ($GITHUB_SSH_KEY_FILE) \n"

    GITHUB_SSH_KEY_FILE_PATH="$HOME/.ssh/jenkins"
    GITHUB_SSH_KEY_FILE="$GITHUB_SSH_KEY_FILE_PATH/id_ed25519"

    echo "A new Github SSH Key will be created with GITHUB_* parameters in ($GITHUB_SSH_KEY_FILE) \n"

    mkdir -p $GITHUB_SSH_KEY_FILE_PATH

    ssh-keygen -q \
        -C $GITHUB_EMAIL \
        -t ed25519 \
        -N $GITHUB_SSH_KEY_PASSPHRASE \
        -f $GITHUB_SSH_KEY_FILE
fi

echo "* IMPORTANT: Paste this Github SSH Key (Public) in your Github account"
echo "Follow this instructions: https://docs.github.com/en/authentication/connecting-to-github-with-ssh \n"
cat $GITHUB_SSH_KEY_FILE.pub
