FROM centos:7
MAINTAINER "kacerr" <kacerr.cz@gmail.com>
ENV container docker

RUN yum update -y && \
    yum -y install mariadb-libs && \
    yum clean all

COPY ./install /tmp/install/

# install rubygems
RUN yum  -y localinstall `find /tmp/install/rpms`


# i want to replace this with something that would not create another layer
# probably get tarball from our repo

RUN yum -y install git hg && \
    adduser redmine && \
    mkdir -p /srv/redmine && \
    hg clone --updaterev 3.0-stable https://bitbucket.org/redmine/redmine-all /srv/redmine/redmine-3.0 && \
    ln -nsf /srv/redmine/redmine-3.0 /srv/redmine/current && \
    chown -R redmine /srv/redmine && \
    cd /srv/redmine/current/plugins/  && \
    git clone https://github.com/jbox-web/redmine_git_hosting.git && \
    git clone https://github.com/jbox-web/redmine_bootstrap_kit.git && \
    cp -f /tmp/install/config/database.yml  /srv/redmine/current/config

ENV RAILS_ENV=production

WORKDIR /srv/redmine/current
RUN gem update bundler && \
    bundle install --without development test && \
    rake generate_secret_token

RUN yum -y localinstall `find /tmp/install/rpms`

CMD ["/bin/bash"]
