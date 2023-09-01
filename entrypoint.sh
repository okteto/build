#!/bin/sh
set -e

tag=$1
file=$2
path=$3
buildargs=$4

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

# if path is ".", override value to empty
# Okteto CLI will run on root
if [ "$path" = "." ]; then
   path=""
fi

command="build"

if [ ! -z $path ]; then
   command=$(eval echo "$command" "$path")
fi

params=$(eval echo --progress plain)

if [ ! -z $tag ]; then
   params=$(eval echo "$params" -t "$tag")
fi

if [ ! -z $file ]; then
   params=$(eval echo "$params" -f "$file")
fi

if [ ! -z $buildargs ]; then
   IFS=',' ;for i in $buildargs; do 
      params="${params} --build-arg=${i}"
   done
fi

echo running: okteto $command $params
okteto $command $params