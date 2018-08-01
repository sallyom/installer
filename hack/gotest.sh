#!/bin/sh

# :) is there a better way to set up the path here in prow?
if [ "$IS_CONTAINER" != "" ]; then
  NEEDPATH='/usr/local/go/src/github.com/openshift/installer'
  mkdir -p $NEEDPATH
  cp -R . $NEEDPATH/.
  cd $NEEDPATH || exit 1
  CGO_ENABLED=0 go test ./installer/...
else
	#in prow, have to figure out how to set workingdir so can just use this instead
    #docker run -e IS_CONTAINER='TRUE' -v "$(pwd)":/usr/local/go/src/github.com/openshift/installer  -w /usr/local/go/src/github.com/openshift/installer quay.io/coreos/golang-testing ./hack/gotest.sh
    docker run -e IS_CONTAINER='TRUE' -v "$(pwd)":"$(pwd)" -w "$(pwd)" quay.io/coreos/golang-testing ./hack/gotest.sh
fi
