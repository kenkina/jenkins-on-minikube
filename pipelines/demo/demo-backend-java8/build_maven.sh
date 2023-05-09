#!/bin/sh

# DELAY in seconds to sleep (default: 1)
DELAY=${1:-1}

echo "CONTAINER_TYPE: $CONTAINER_TYPE $WORD"
mvn --version

echo "Sleeping for $DELAY DELAY..."
sleep $DELAY
