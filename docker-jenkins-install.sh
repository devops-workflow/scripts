#!/bin/bash

###
### Jenkins setup
###
jenkinsHome=/home/jenkins
jenkinsDir=/mnt/software/servers/jenkins-master
#jenkinsDir=${jenkinsHome}/jenkins
jenkinsUser=jenkins
useradd -c "Jenkins server" -G docker -m -d ${jenkinsHome} ${jenkinsUser}
sudo -u ${jenkinsUser} mkdir -p ${jenkinsDir} ${jenkinsHome}/bin
sudo -u ${jenkinsUser} cp *.sh ${jenkinsHome}/bin
sudo -u ${jenkinsUser} ln -s ${jenkinsDir} ${jenkinsHome}/jenkins

###
### Start Jenkins container
###
# TODO: change to specify user
${jenkinsHome}/bin/docker-jenkins-start.sh
