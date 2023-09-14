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

if [ -n "$OKTETO_CA_CERT" ]; then
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

if [ -n "$path" ]; then
   command=$(eval echo "$command" "$path")
fi

params=$(eval echo --progress plain)

if [ -n "$tag" ]; then
   params=$(eval echo "$params" -t "$tag")
fi

if [ -n "$file" ]; then
   params=$(eval echo "$params" -f "$file")
fi

if [ -n "$buildargs" ]; then
   IFS=',' 
   # shellcheck disable=SC2086
   set -- $buildargs
   unset IFS

   while [ $# -gt 0 ]; do
      params=$(eval echo "$params" --build-arg "$1")
      shift
   done
fi

if [ "$nocache" = "true" ]; then
      params=$(eval echo "$params" --no-cache)
fi

if [ -n "$cachefrom" ]; then
   IFS=','
   # shellcheck disable=SC2086
   set -- $cachefrom
   unset IFS

   while [ $# -gt 0 ]; do
      params=$(eval echo "$params" --cache-from "$1")
      shift
   done
fi

if [ -n "$exportcache" ]; then
   IFS=','
   # shellcheck disable=SC2086
   set -- $cachefrom
   unset IFS

   while [ $# -gt 0 ]; do
      params=$(eval echo "$params" --export-cache "$1")
      shift
   done
fi

if [ -n "$secrets" ]; then
   IFS=';'
   # shellcheck disable=SC2086
   set -- $secrets
   unset IFS

   while [ $# -gt 0 ]; do
      params=$(eval echo "$params" --secret "$1")
      shift
   done
fi

echo running: okteto "$command" "$params"
# shellcheck disable=SC2086
okteto $command $params