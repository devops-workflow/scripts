#!/bin/bash

gitLabUser=gitlab
gitLabHome=$(getent passwd ${gitLabUser} | cut -d: -f6)
${gitLabHome}/bin/docker-gitlab-stop.sh
docker pull gitlab/gitlab-ce:latest
${gitLabHome}/bin/docker-gitlab-start.sh
