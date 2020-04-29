FROM centos:8

ENV REPO_YUM_UPDATE_METADATA_PATH ''
RUN yum install -y createrepo && yum clean all

VOLUME /data

COPY updaterepo.sh /updaterepo.sh
RUN chmod +x /updaterepo.sh

CMD ["/updaterepo.sh", "$REPO_YUM_UPDATE_METADATA_PATH"]
