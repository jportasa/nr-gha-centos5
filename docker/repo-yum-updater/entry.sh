#!/bin/bash

set -e
set -x

LOCAL_REPO_PATH="/mnt/$REPO_YUM_UPDATE_METADATA_PATH"

echo "Updating $REPO_YUM_UPDATE_METADATA_PATH"
find ${LOCAL_REPO_PATH} -name repodata | xargs -n 1 rm -rf
time createrepo --update -s sha "${LOCAL_REPO_PATH}"

