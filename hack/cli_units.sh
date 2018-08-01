#!/bin/sh

# in prow, already in container, so no 'docker run'
if [ "$IS_CONTAINER" != "" ]; then
  if ! go test ./installer/...; then
    export FAILED=true
  fi
  if [ "$FAILED" != "" ]; then
    exit 1
  fi
  echo cli_units passed
else
    docker run -e IS_CONTAINER='TRUE' --rm -v $PWD:/go/src/github.com/openshift/installer -w /go/src/github.com/openshift/installer quay.io/coreos/golang-testing go test ./installer/...
fi
