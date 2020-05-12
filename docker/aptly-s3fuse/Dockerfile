FROM debian:stretch

# S3-fuse
ENV S3FS_VERSION=1.84 S3FS_SHA1=9322692aa797fcc6fefe300086e07b33bbc735c9
ADD *.sh /
RUN chmod a+x /build-s3fs.sh
RUN chmod a+x /entry.sh
RUN /build-s3fs.sh

# Aptly Install
ARG APTLY_VERSION
RUN set -x \
 && apt-get update \
 && apt-get install -y gnupg1 gpgv1 \
 && apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys ED75B5A4483DA07C \
 && echo 'deb http://repo.aptly.info/ squeeze main' > /etc/apt/sources.list.d/aptly.list \
 && apt-get update \
 && if [ -z "$APTLY_VERSION" ]; then apt-get install -y aptly; else apt-get install -y "aptly=$APTLY_VERSION"; fi
# && apt-get clean

# Install aws-cli
RUN apt-get install -y wget curl unzip \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && ln -s /usr/local/bin/aws /usr/bin/aws

RUN apt-get clean

ADD aptly.conf /etc/aptly.conf
VOLUME ["/aptly"]

ENTRYPOINT ["/entry.sh"]