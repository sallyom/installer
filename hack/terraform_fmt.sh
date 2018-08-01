#!/bin/sh

# in prow, already in container, so no 'docker run'
if [ "$IS_CONTAINER" = "" ]; then
  set -x
  chmod 0777 "$PWD"
  docker run --rm -v"$PWD":"$PWD":rw -w "$PWD" quay.io/coreos/tectonic-builder:bazel-v0.3
fi
set +x
bazel --output_base=.cache build tarball
tar -zxf bazel-bin/tectonic-dev.tar.gz
cd tectonic-dev || exit 1
PATH=$(pwd)/installer:$PATH
if ! terraform fmt -list -check -write=false; then
  export FAILED=true
fi
if [ "$FAILED" != "" ]; then
  exit 1
fi
echo terraform_fmt passed
