#!/bin/bash

#mountHome=/data

# Setup ssh jenkins slave system
#
slaveUser='jenkins-slave'
#slaveHome="${mountHome}/jenkins/JenkinsSlave"
slaveHome='/jenkins/JenkinsSlave'
slaveDir=${slaveHome}/jenkins
slaveUser='jenkins-slave'

###
### Setup Slave
###
# create user and group
# getent returns line from file
#if [ ! $(getent group ${slaveGroup}) ]; then
#  groupadd ${slaveGroup}
#fi
# id -u ${slaveUser} # then test $?
getent passwd ${slaveUser} > /dev/null
if [ $? -ne 0 ]; then
  useradd -c 'Jenkins Slave' -G docker -m -d ${slaveHome} -s /bin/bash ${slaveUser}
  # Create ssh key
  cat /dev/zero | sudo -u ${slaveUser} ssh-keygen -C "Jenkins-Host-Slave" -t rsa -N ''
  # -f <file> # if no path will create in cur dir
  #sudo -u ${slaveUser} "cd ~${slaveUser}/.ssh && cp id_rsa.pub authorized_keys"
fi
if [ ! -d ${slaveDir} ]; then
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
# PyEnv requirements
#yum install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel
# PyEnv needs developer apps
#yum group install 'Development tools'
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


