#!/bin/sh
set -e

file=$2

BUILDPARAMS=""

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

params=$(eval echo --progress plain -f "$file")

params=$(eval echo "$params")

echo running: okteto build $params
okteto build $params