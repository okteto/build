#!/bin/sh
set -e

tag=$1
file=$2
path=$3
buildargs=$4
global=$5

if [ -n "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

params=""

if [ -n "$tag" ]; then
params="${params} --tag=${tag}"
fi

if [ -n "$file" ]; then
params="${params} --file=${file}"
fi

if [ "$global" = "true" ]; then
params="${params} --global"
fi

if [ -n "$buildargs" ]; then
IFS=',' ;for i in $buildargs; do 
    params="${params} --build-arg=${i}"
done
fi

if [ -n "$path" ]; then
cd "$path"
fi

echo running: "okteto build $params"
okteto build $params