Inspired by:

https://github.com/josh9398/dockerfiles
https://github.com/s3fs-fuse/s3fs-fuse

docker run -d --privileged -e S3_BUCKET="nr-test" -e S3_ENDPOINT="https://s3.amazonaws.com" jportasa/s3fs:1.0

## IAM Policy
```
- PolicyName: DestinationBucketAccessPolicy
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
          - Effect: Allow
            Action:
              - s3:ListBucket
              - s3:DeleteObject
              - s3:GetObject
              - s3:PutObject
              - s3:RestoreObject
            Resource:
              - !Sub 'arn:aws:s3:::${DestinationBucket}/*'
              - !Sub 'arn:aws:s3:::${DestinationBucket}'
```

In EKS, you will have to create a serviceaccount mapped to he corresponding IAM role.
You can add this mapping with eksctl.