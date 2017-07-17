#!/bin/bash

dirDataBase=/mnt/software/servers/gitlab
dirEtc=${dirDataBase}/etc
dirLogs=${dirDataBase}/logs
dirData=${dirDataBase}/data
gitLabHome=/home/gitlab

###
### GitLab setup
###
gitLabUser=gitlab
useradd -c "GitLab server" -G docker -m -d ${gitLabHome} ${gitLabUser}
sudo -u ${gitLabUser} mkdir -p ${gitLabHome}/bin
#sudo -u ${gitLabUser} cp *.sh ${gitLabHome}/bin

# Create volume locations
sudo -u ${gitLabUser} mkdir -p ${gitLabHome}/gitlab
for D in ${dirData} ${dirEtc} ${dirLogs}; do
  sudo -u ${gitLabUser} mkdir -p ${D}
  #chmod
  sudo -u ${gitLabUser} ln -s ${D} "${gitLabHome}/gitlab/${D##*/}"
done

###
### Start GitLab container
###
# TODO: change to specify user
${gitLabHome}/bin/docker-gitlab-start.sh

exit
# opt override config file
#--env GITLAB_OMNIBUS_CONFIG="external_url 'http://my.domain.com/'; gitlab_rails['lfs_enabled'] = true;" \

docker run --detach \
    --hostname gitlab.example.com \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume ${dirEtc}:/etc/gitlab \
    --volume ${dirLogs}:/var/log/gitlab \
    --volume ${dirData}:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

# config
docker exec -it gitlab vi /etc/gitlab/gitlab.rb

# Restart after configuring
docker restart gitlab

# Upgrade
docker stop gitlab
docker rm gitlab
docker pull gitlab/gitlab-ce:latest
