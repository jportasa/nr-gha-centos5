#!/bin/bash
set -e
set -x

export S3_ACL=${S3_ACL:-private}

if [ "$IAM_ROLE" == "none" ]; then
  export AWSACCESSKEYID=${AWSACCESSKEYID:-$AWS_ACCESS_KEY_ID}
  export AWSSECRETACCESSKEY=${AWSSECRETACCESSKEY:-$AWS_SECRET_ACCESS_KEY}
  echo 'IAM_ROLE is not set - mounting S3 with credentials from ENV'
  /usr/bin/s3fs ${S3_BUCKET} ${MOUNT_POINT} -o nosuid,nonempty,nodev,allow_other,default_acl=${S3_ACL},retries=5
else
  echo 'IAM_ROLE is set - using it to mount S3'
  /usr/bin/s3fs ${S3_BUCKET} ${MOUNT_POINT} -o iam_role=${IAM_ROLE},nosuid,nonempty,nodev,allow_other,default_acl=${S3_ACL},retries=5
fi

sleep 600



