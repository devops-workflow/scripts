#!/bin/bash

jenkinsUser=jenkins
jenkinsHome=$(getent passwd ${jenkinsUser} | cut -d: -f6)
${jenkinsHome}/bin/docker-jenkins-stop.sh
docker pull jenkins:latest
${jenkinsHome}/bin/docker-jenkins-start.sh
