#!/bin/sh
set -e

tag=$1
file=$2
path=$3
buildargs=$4
global=$5

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

params=""

if [ ! -z $tag ]; then
params="${params} --tag=${tag}"
fi

if [ ! -z $file ]; then
params="${params} --file=${file}"
fi

if [ ! -z $global ]; then
params="${params} --global"
fi

if [ ! -z $buildargs ]; then
params="${params} --buildargs=${buildargs}"
fi


echo running: okteto build $params
okteto build $params