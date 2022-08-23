FROM centos:7

LABEL maintainer="Samuel Bernard samuel.bernard@gmail.com"

ENV LANG=en_US.UTF-8

# Let's run stuff
RUN \
# Classic yum update
  yum -y update; \
# Basic latest chef install with useful package
  curl -L https://omnitruck.chef.io/install.sh | bash; \
  yum install -y iproute sudo less vim tree; \
# Installing Busser
  GEM_HOME="/tmp/verifier/gems" \
  GEM_PATH="/tmp/verifier/gems" \
  GEM_CACHE="/tmp/verifier/gems/cache" \
  /opt/chef/embedded/bin/gem install busser --no-document \
    --no-format-executable -n /tmp/verifier/bin --no-user-install; \
# Busser plugins
  GEM_HOME="/tmp/verifier/gems" \
  GEM_PATH="/tmp/verifier/gems" \
  GEM_CACHE="/tmp/verifier/gems/cache" \
  /opt/chef/embedded/bin/gem install \
    busser-serverspec serverspec --no-document; \
# Bundler
  GEM_HOME="/tmp/verifier/gems" \
  GEM_PATH="/tmp/verifier/gems" \
  GEM_CACHE="/tmp/verifier/gems/cache" \
  /opt/chef/embedded/bin/gem install bundler --no-document; \
# Webmock can be very useful to test cookbooks
  GEM_HOME="/tmp/verifier/gems" \
  GEM_PATH="/tmp/verifier/gems" \
  GEM_CACHE="/tmp/verifier/gems/cache" \
  /opt/chef/embedded/bin/gem install \
    webmock --no-document; \
# Generate locale, remove a chef warning
  localedef -v -c -i en_US -f UTF-8 en_US.UTF-8; \
# Last command, we clean yum files everything
  yum clean all && rm -rf /var/cache/yum

RUN \
  # Mask remount-fs as it will always fail in a docker
  systemctl mask systemd-remount-fs.service sys-fs-fuse-connections.mount

VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
