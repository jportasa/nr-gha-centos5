#!/usr/bin/env bash

echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > /etc/passwd-s3fs
chmod 0400 /etc/passwd-s3fs
