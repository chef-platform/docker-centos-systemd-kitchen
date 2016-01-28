FROM centos:centos7.2.1511
MAINTAINER Samuel Bernard "samuel.bernard@s4m.io"

RUN yum -y update
RUN systemctl mask systemd-remount-fs.service

RUN CHEFURL="https://opscode-omnibus-packages.s3.amazonaws.com"; \
    yum install -y ${CHEFURL}/el/7/x86_64/chef-12.6.0-1.el7.x86_64.rpm
RUN yum install -y iproute sudo

RUN GEM_HOME="/tmp/verifier/gems" \
    GEM_PATH="/tmp/verifier/gems" \
    GEM_CACHE="/tmp/verifier/gems/cache" \
    /opt/chef/embedded/bin/gem install busser --no-rdoc --no-ri \
      --no-format-executable -n /tmp/verifier/bin --no-user-install

RUN GEM_HOME="/tmp/verifier/gems" \
    GEM_PATH="/tmp/verifier/gems" \
    GEM_CACHE="/tmp/verifier/gems/cache" \
    /opt/chef/embedded/bin/gem install --no-rdoc --no-ri \
      thor busser-serverspec serverspec bundler

RUN yum clean all

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/sys/fs/fuse/connections"]
VOLUME ["/run"]

CMD  ["/usr/lib/systemd/systemd"]
