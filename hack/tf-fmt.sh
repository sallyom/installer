#!/bin/sh

# in prow, already in container, so no 'docker run'
if [ "$IS_CONTAINER" != "" ]; then
  export PATH=/tmp:$PATH
   INSTALLER_REPO=$(pwd)
   cd /tmp || exit 1
   wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
   unzip terraform_0.11.7_linux_amd64.zip
   set -x
   cd "$INSTALLER_REPO" || exit 1
  /tmp/terraform fmt -list -check -write=false
else
  docker run -e IS_CONTAINER='TRUE' \
      --rm -v "$PWD":"$PWD":ro -w "$PWD" -v /tmp:/tmp:rw \
      -w "$PWD" quay.io/coreos/golang-testing ./hack/tf-fmt.sh
fi
