#!/bin/bash
#
# Install and setup docker service
#
dirDocker=/docker/docker

if [ -f /etc/lsb-release ]; then
  OS=$(grep DISTRIB_ID /etc/lsb-release | cut -d= -f2)
  Release=$(grep DISTRIB_RELEASE /etc/lsb-release | cut -d= -f2)
  CodeName=$(grep DISTRIB_CODENAME /etc/lsb-release | cut -d= -f2)
fi
if [ "$OS" == 'Ubuntu' ]; then
  mkdir -p ${dirDocker}
  ln -s ${dirDocker} /var/lib/docker
  # Ubuntu
  apt-get update
  apt-get -y install apt-transport-https ca-certificates
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    # add Docker repo
    echo "deb https://apt.dockerproject.org/repo ubuntu-${CodeName} main" > /etc/apt/sources.list.d/docker.list
  fi
  apt-get update
  apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
  apt-get -y install docker-engine
  # 15.04+
  # systemctl enable docker
  service docker start
  groupadd docker
  # Give user access to docker service
  #usermod -aG docker $USER
  # Upgrading
  #apt-get upgrade docker-engine
fi
