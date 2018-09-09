#!/bin/bash

set -u
set -e
set -o pipefail

MAX_ATTEMPTS=5
ATTEMPTS=0

echo "waiting for abi file to be available..."
while [ ! -f "$CONTRACT_ABI_FILENAME" ] && [ "$ATTEMPTS" -lt "$MAX_ATTEMPTS" ]; do
  echo "Not here yet. $ATTEMPTS/$MAX_ATTEMPTS"
  sleep 5
  ATTEMPTS=$((ATTEMPTS+1))
done

if [ "$ATTEMPTS" -eq "$MAX_ATTEMPTS" ]; then
  echo "abi file did not become available. exiting."
  exit -1
fi

echo "File arrived on attempt $ATTEMPTS/$MAX_ATTEMPTS"

exec /app/main
