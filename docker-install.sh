#!/bin/bash
#
# Install and setup docker service
#
mountHome=/data
dirDocker=${mountHome}/docker/docker

### Determine OS
if [ -f /etc/os-release ]; then
  OS=$(grep -E ^ID= /etc/os-release | cut -d= -f2)
  # TODO: strip quotes
elif [ -f /etc/lsb-release ]; then
  OS=$(grep DISTRIB_ID /etc/lsb-release | cut -d= -f2)
  Release=$(grep DISTRIB_RELEASE /etc/lsb-release | cut -d= -f2)
  CodeName=$(grep DISTRIB_CODENAME /etc/lsb-release | cut -d= -f2)
fi
### Install
mkdir -p ${dirDocker}
ln -s ${dirDocker} /var/lib/docker
if [ "$OS" == 'amzn' ]; then
  # RedHat like
  yum -y update
  #yum -y install lsb yum-utils device-mapper-persistent-data lvm2
  yum -y install docker
  service docker start
  usermod -a -G docker ec2-user
elif [ "$OS" == 'Ubuntu' ]; then
  # Ubuntu 16.04
  apt-get update
  apt-get -y install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  #apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  #if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  #  # add Docker repo
  #  echo "deb https://apt.dockerproject.org/repo ubuntu-${CodeName} main" > /etc/apt/sources.list.d/docker.list
  #fi
  apt-get update
  apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
  apt-get -y install docker-ce
  # 15.04+
  systemctl enable docker
  #service docker start
  groupadd docker
  # Give user access to docker service
  #usermod -aG docker $USER
  # Upgrading
  #apt-get upgrade docker-engine
fi
