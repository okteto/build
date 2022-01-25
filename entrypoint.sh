#!/bin/sh
set -e

tag=$1
file=$2
path=$3
args=$4
global=$5

BUILDPARAMS=""

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert
   update-ca-certificates
fi

if [ ! -z "${INPUT_BUILDARGS}" ]; then
  for ARG in $(echo "${INPUT_BUILDARGS}" | tr ',' '\n'); do
    BUILDPARAMS="${BUILDPARAMS} --build-arg ${ARG}=\$${ARG}"
  done
fi

params=$(eval echo --progress plain -t "$tag" -f "$file" "$BUILDPARAMS" "$path")
if [ -z "$tag" ]; then
  params=$(eval echo --progress plain -f "$file" "$BUILDPARAMS" "$path")
fi

if [ "$OKTETO_ENABLE_MANIFEST_V2" = true && "$global" == true ]; then
    params=$(eval echo --progress plain --global -f "$file" "$BUILDPARAMS" "$path")
fi

echo running: okteto build $params
okteto build $params