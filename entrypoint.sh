#!/bin/sh
set -e

file=$1
services=$2
global=$3

BUILDPARAMS=""

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert
   update-ca-certificates
fi

if [ -z "$file" ]; then
  file="okteto.yml"
fi

params=$(eval echo --progress plain -f "$file" )

if [ "$global" = "true" ]; then
    params="${params} --global"
fi

SERVICESPARAMS=""
if [ ! -z "$services" ]; then
  for s in $(echo $services | tr "," "\n"); do
    SERVICESPARAMS="${SERVICESPARAMS} ${s}"
  done
    params="${params} ${SERVICESPARAMS}"
fi

params=$(eval echo "$params")

echo running: okteto build $params
okteto build $params