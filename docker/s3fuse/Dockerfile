FROM ubuntu:16.04
MAINTAINER Xueshan Feng <xueshan.feng@gmail.com>

ENV VERSION 1.83

ENV IAM_ROLE=none
ENV MOUNT_POINT=${MOUNT_POINT}
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_REGION=${AWS_REGION}
ENV S3_BUCKET=${S3_BUCKET}
ENV REPO_YUM_UPDATE_METADATA_PATH=${REPO_YUM_UPDATE_METADATA_PATH}

RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
 automake \
 curl \
 build-essential \
 libcurl4-openssl-dev \
 libssl-dev \
 libfuse-dev \
 libtool \
 libxml2-dev mime-support \
 tar \
 pkg-config \
 && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v${VERSION}.tar.gz | tar zxv -C /usr/src
RUN cd /usr/src/s3fs-fuse-${VERSION} && ./autogen.sh && ./configure --prefix=/usr && make && make install

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]