FROM centos:8

RUN yum install -y createrepo && yum clean all

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]
