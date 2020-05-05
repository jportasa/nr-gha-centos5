FROM debian:stretch

ARG APTLY_VERSION
RUN set -x \
 && apt-get update \
 && apt-get install -y gnupg1 gpgv1 \
 && apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys ED75B5A4483DA07C \
 && echo 'deb http://repo.aptly.info/ squeeze main' > /etc/apt/sources.list.d/aptly.list \
 && apt-get update \
 && if [ -z "$APTLY_VERSION" ]; then apt-get install -y aptly; else apt-get install -y "aptly=$APTLY_VERSION"; fi \
 && apt-get clean

ADD aptly.conf /etc/aptly.conf
VOLUME ["/aptly"]