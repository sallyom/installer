#!/bin/sh

# in prow, already in container, so no 'docker run'
if [ "$IS_CONTAINER" != "" ]; then
  bazel --output_base=.cache build tarball
  tar -zxf bazel-bin/tectonic-dev.tar.gz
  cd tectonic-dev || exit 1
  PATH=$(pwd)/installer:$PATH
  terraform fmt -list -check -write=false
else
  docker run -e IS_CONTAINER='TRUE' --rm -v"$PWD":"$PWD":rw -w "$PWD" quay.io/coreos/tectonic-builder:bazel-v0.3 ./hack/terraform_fmt.sh
fi

