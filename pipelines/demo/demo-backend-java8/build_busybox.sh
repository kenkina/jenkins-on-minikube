#!/bin/sh

# DELAY in seconds to sleep (default: 1)
DELAY=${1:-1}

echo "CONTAINER_TYPE: $CONTAINER_TYPE $WORD"
busybox | head -1

echo "Sleeping for $DELAY DELAY..."
sleep $DELAY
