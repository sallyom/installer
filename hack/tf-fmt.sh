#!/bin/sh

# in prow, already in container, so no 'docker run'
if [ "$IS_CONTAINER" != "" ]; then
  /terraform fmt -list -check -write=false
else
  docker run --rm -v "$PWD":"$PWD":ro -v /tmp:/tmp:rw -w "$PWD" quay.io/coreos/terraform-alpine:v0.11.7 /terraform fmt -list -check -write=false
fi

