FROM centos:centos7.2.1511
MAINTAINER Samuel Bernard "samuel.bernard@s4m.io"

# Let's run stuff
RUN \

# Classic yum update
  yum -y update; \

# Mask remount-fs as it will always fail in a docker
  systemctl mask systemd-remount-fs.service; \

# Basic chef install with useful package
  CHEFURL="https://packages.chef.io/stable"; \
  yum install -y ${CHEFURL}/el/7/chef-12.9.38-1.el7.x86_64.rpm; \
  yum install -y iproute sudo; \

# Installing Busser
  GEM_HOME="/tmp/verifier/gems" \
  GEM_PATH="/tmp/verifier/gems" \
  GEM_CACHE="/tmp/verifier/gems/cache" \
  /opt/chef/embedded/bin/gem install busser --no-rdoc --no-ri \
    --no-format-executable -n /tmp/verifier/bin --no-user-install; \

# Busser plugins
  GEM_HOME="/tmp/verifier/gems" \
  GEM_PATH="/tmp/verifier/gems" \
  GEM_CACHE="/tmp/verifier/gems/cache" \
  /opt/chef/embedded/bin/gem install \
    busser-serverspec serverspec --no-rdoc --no-ri; \

# Webmock can be very useful to test cookbooks
  GEM_HOME="/tmp/verifier/gems" \
  GEM_PATH="/tmp/verifier/gems" \
  GEM_CACHE="/tmp/verifier/gems/cache" \
  /opt/chef/embedded/bin/gem install \
    webmock --no-rdoc --no-ri; \

# Last command, we clean yum files everything
  yum clean all;

VOLUME ["/sys/fs/cgroup", "/sys/fs/fuse/connections", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
