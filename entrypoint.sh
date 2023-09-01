#!/bin/sh
set -e

tag=$1
file=$2
path=$3
buildargs=$4
nocache=$5
cachefrom=$6
exportcache=$7
secrets=$8

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
   IFS=',' read -ra ARG <<< "$buildargs"
   for i in "${ARG[@]}"; do 
      params=$(eval echo "$params" --build-arg "$i")
   done
fi

if [ "$nocache" = "true" ]; then
   params="${params} --no-cache"
fi

if [ ! -z $cachefrom ]; then
   IFS=',' read -ra CACHEF <<< "$cachefrom"
   for i in "${CACHEF[@]}"; do 
      params=$(eval echo "$params" --cache-from "$i")
   done
fi

if [ ! -z $exportcache ]; then
   IFS=',' read -ra ECACHE <<< "$exportcache"
   for i in "${ECACHE[@]}"; do 
      params=$(eval echo "$params" --export-cache "$i")
   done
fi

if [ ! -z $secrets ]; then
   IFS=';' read -ra SECRET <<< "$secrets"
   for i in "${SECRET[@]}"; do 
      params=$(eval echo "$params" --secret "$i")
   done
fi

echo running: okteto $command $params
okteto $command $params