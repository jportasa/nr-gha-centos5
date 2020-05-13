FROM centos:5
ENV GO_VERSION 1.14
ENV GIT_VERSION 1.8.2.3

# This image extends a basic Centos 5 system by installing some packages
# needed for developmemt.

# Since Centos5 is EOL since April 2017, yum needs to check the "vault"-repositories
# (copied from https://github.com/astj/docker-centos5-vault )
COPY yum.repos.d /etc/yum.repos.d/

# Git install
RUN yum install -y wget gcc make perl tcl gettext curl-devel
RUN wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz && \
    tar -xf git-$GIT_VERSION.tar.gz && \
    rm git-$GIT_VERSION.tar.gz && \
    cd git-$GIT_VERSION && \
    ./configure && \
    make && \
    make install

# Go install
RUN wget -q --no-check-certificate https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz; \
    tar -xf go$GO_VERSION.linux-amd64.tar.gz; \
    rm go$GO_VERSION.linux-amd64.tar.gz; \
    chown -R root:root ./go; \
    mv go /usr/local

ENV PATH "$PATH:/usr/local/go/bin"
