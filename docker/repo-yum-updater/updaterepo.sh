#!/bin/bash

set -e
set -x

REPO=${1}

LOCAL_REPO_PATH="/mnt/repo/${REPO}"
if ! [[ -d "${LOCAL_REPO_PATH}" ]]; then
    echo "No repo ${LOCAL_REPO_PATH} found"
    exit 1
fi
echo "Updating ${REPO}"
find ${LOCAL_REPO_PATH} -name repodata | xargs -n 1 rm -rf
time createrepo --update -s sha "${LOCAL_REPO_PATH}"

