#!/bin/bash
set -e
set -x

export S3_ACL=${S3_ACL:-private}

if [ "$IAM_ROLE" == "none" ]; then
  export AWSACCESSKEYID=${AWSACCESSKEYID:-$AWS_ACCESS_KEY_ID}
  export AWSSECRETACCESSKEY=${AWSSECRETACCESSKEY:-$AWS_SECRET_ACCESS_KEY}
  echo 'IAM_ROLE is not set - mounting S3 with credentials from ENV'
  /usr/bin/s3fs ${S3_BUCKET} ${MOUNT_POINT} -o dbglevel=warning
else
  echo 'IAM_ROLE is set - using it to mount S3'
  /usr/bin/s3fs ${S3_BUCKET} ${MOUNT_POINT} -o iam_role=${IAM_ROLE}  dbglevel=warning
fi

# This sleep is needed because other containers are using this s3 mount
sleep 10000



