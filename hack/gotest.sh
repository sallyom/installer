#!/bin/sh

# in prow, already in container, so no 'docker run'
if [ "$IS_CONTAINER" != "" ]; then
  echo Where am I?
  pwd
  echo go env
  go env
  GOPATH=$HOME/go CGO_ENABLED=0 go test -cover ./installer/pkg/...
else
    docker run -e IS_CONTAINER='TRUE' -v "$(pwd)":/usr/local/go/src/github.com/openshift/installer  -w /usr/local/go/src/github.com/openshift/installer quay.io/coreos/golang-testing ./hack/gotest.sh
fi

