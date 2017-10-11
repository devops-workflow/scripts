#!/bin/bash

mountHome=/data

# Setup 2 file systems: Jenkins data, Docker data
for D in JenkinsSlave docker; do
  if [ ! -d "${mountHome}/${D}" ]; then
    # Create mount points
    mkdir -p ${mountHome}/${D}
    chmod 0000 ${mountHome}/${D}
  fi
done
#Create filesystems
for D in sdb sdc; do
  mkfs -t ext4 /dev/${D}
done
cat <<FSTAB >>/etc/fstab
/dev/sdb	${mountHome}/docker	ext4	defaults	0 2
/dev/sdc	${mountHome}/JenkinsSlave	ext4	defaults	0 2
FSTAB
mount -a

# Install docker

# Setup ssh jenkins slave system
#
slaveUser='jenkins-slave'
#slaveHome="${mountHome}/jenkins/JenkinsSlave"
#slaveHome='/jenkins/JenkinsSlave'
slaveHome="${mountHome}/JenkinsSlave/jenkins"
slaveDir=${slaveHome}/jenkins
slaveUser='jenkins-slave'

###
### Setup Slave
###
# create user and group
getent passwd ${slaveUser} > /dev/null
if [ $? -ne 0 ]; then
  useradd -c 'Jenkins Slave' -G docker -m -d ${slaveHome} -s /bin/bash ${slaveUser}
  # Create ssh key
  cat /dev/zero | sudo -u ${slaveUser} ssh-keygen -C "Jenkins-Host-Slave" -t rsa -N ''
  # -f <file> # if no path will create in cur dir
  sudo -u ${slaveUser} -H bash -c "cd ~/.ssh && cp id_rsa.pub authorized_keys"
fi
if [ ! -d ${slaveDir} ]; then
  #sudo -u ${slaveUser} ln -s ${jenkinsDir} ${jenkinsHome}/jenkins
  sudo -u ${slaveUser} mkdir -p ${slaveDir}
  #chown -R ${slaveUser}:${slaveGroup} ${dirSlave}
fi

# if /bin/sh is not bash, relink to bash
# rm /bin/sh
# cd /bin && ln -s bash sh

# Requirements for PyEnv https://github.com/yyuu/pyenv/wiki/Common-build-problems
###
### RedHat/CentOS
###
# Basics for Jenkins
#yum -y install git lsb
# PyEnv requirements
#yum -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel
# PyEnv requires developer apps
#yum -y group install 'Development tools'
# Additional utilities
#yum -y install unzip

# Kafka python client requirements
#rpm --import http://packages.confluent.io/rpm/3.1/archive.key
# For RedHat/CentOS 7
#cat <<REPO >/etc/yum.repo.d/confluent.REPO
#[Confluent.dist]
#name=Confluent repository (dist)
#baseurl=http://packages.confluent.io/rpm/3.1/7
#gpgcheck=1
#gpgkey=http://packages.confluent.io/rpm/3.1/archive.key
#enabled=1
#
#[Confluent]
#name=Confluent repository
#baseurl=http://packages.confluent.io/rpm/3.1
#gpgcheck=1
#gpgkey=http://packages.confluent.io/rpm/3.1/archive.key
#enabled=1
#REPO
#yum install librdkafka-devel
###
### Ubuntu
###
# Basics for Jenkins
#apt-get -y install git lsb
# PyEnv requirements
#apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils
# Additional utilities
#apt-get install -y unzip

# Kafka python client requirements
#wget -qO - http://packages.confluent.io/deb/3.1/archive.key | sudo apt-key add -
#add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/3.1 stable main"
#apt-get install librdkafka-dev
