docker-centos-systemd-kitchen
=============================

Docker image for a Centos 7+ with a working Systemd, provisionned with Chef
to be used in Test Kitchen.

Test it easily with:

    # Get the image
    docker pull chefplatform/centos-systemd-kitchen
    # Run it (do not forget cgroup volume for systemd)
    docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name csk \
      chefplatform/centos-systemd-kitchen
    # Open a shell in it, you can try 'systemctl' for instance
    docker exec -it csk bash -c 'TERM=xterm bash'
    # Kill and remove the container
    docker kill csk; docker rm csk
