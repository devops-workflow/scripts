#!/bin/bash

# Setup ssh jenkins slave system
#
slaveUser='jenkins-slave'
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
  #sudo -u ${slaveUser} ssh-keygen -C "Jenkins-Host-Slave" -t rsa -N ''
  # -f <file> # if no path will create in cur dir
  # cp id_rsa.pub authorized_keys
fi
if [ ! -d ${slaveDir} ]; then
  sudo -u ${slaveUser} mkdir -p ${slaveDir}
  #chown -R ${slaveUser}:${slaveGroup} ${dirSlave}
fi

# Requirements for PyEnv https://github.com/yyuu/pyenv/wiki/Common-build-problems
# RedHat
#yum install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel
# Ubuntu
#apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils
