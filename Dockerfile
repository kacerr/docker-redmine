FROM centos:7
MAINTAINER "kacerr" <kacerr.cz@gmail.com>
ENV container docker

RUN yum update -y

CMD ["/bin/bash"]
