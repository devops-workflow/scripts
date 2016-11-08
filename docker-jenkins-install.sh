#!/bin/bash

###
### Jenkins setup
###
jenkinsUser=jenkins
jenkinsHome=/jenkins/jenkins
jenkinsDir=${jenkinsHome}/jenkins
useradd -c "Jenkins server" -G docker -m -d ${jenkinsHome} ${jenkinsUser}
sudo -u ${jenkinsUser} mkdir -p ${jenkinsDir} ${jenkinsHome}/bin
sudo -u ${jenkinsUser} cp *.sh ${jenkinsHome}/bin

###
### Start Jenkins container
###
# TODO: change to specify user
${jenkinsHome}/bin/docker-jenkins-start.sh
