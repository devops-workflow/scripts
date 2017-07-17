#!/bin/bash

###
### Start GitLab container
###
gitLabUser=gitlab
gitLabHome=$(getent passwd ${gitLabUser} | cut -d: -f6)
uid=$(getent passwd ${gitLabUser} | cut -d: -f3)
gid=$(getent passwd ${gitLabUser} | cut -d: -f4)

# Force ipv4, firewall issues
-u ${uid}:${gid} \
docker run --detach \
    --hostname gitlab.example.com \
    --publish 443:443 --publish 80:80 --publish 122:22 \
    --name gitlab \
    --restart always \
    --volume ${gitLabHome}/gitlab/etc:/etc/gitlab \
    --volume ${gitLabHome}/gitlab/logs:/var/log/gitlab \
    --volume ${gitLabHome}/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

exit
# On first run, there will be a password in the log or in volume
#docker logs jenkins
echo "Initial setup password can be found with:"
echo "cat ${jenkinsDir}/secrets/initialAdminPassword"
