```
docker run -it --privileged \
  -e AWS_ACCESS_KEY_ID=AKIA54FIHR7B3T5Q4OGS \
  -e AWS_SECRET_ACCESS_KEY=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 \
  -e AWS_STORAGE_BUCKET_NAME=nr-repo-apt \
  -e AWS_S3_MOUNTPOINT=/mnt/aptly \
  jportasa/aptly-s3fuse:1.0
```