#!/bin/bash

###
### Start Jenkins container
###
jenkinsUser=jenkins
jenkinsHome=$(getent passwd ${jenkinsUser} | cut -d: -f6)
uid=$(getent passwd ${jenkinsUser} | cut -d: -f3)
gid=$(getent passwd ${jenkinsUser} | cut -d: -f4)
jenkinsDir="${jenkinsHome}/jenkins"
JAVA_OPTS="-Djava.awt.headless=true -Dhudson.model.DirectoryBrowserSupport.CSP=\"\\\"Sandbox allow-scripts; default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline';\\\"\""
# Additional ports, but not exposed: -p 36488:36488/udp
# Additional exposed ports: 50000
# --env available: JAVA_OPTS, JENKINS_OPTS

# Quoting issue
#docker run --name jenkins -d --restart=always -p 8080:8080 -p 5000:5000 -v ${jenkins_home}:/var/jenkins_home --env JAVA_OPTS="${JAVA_OPTS}" jenkins
# Didn't come up
#docker run --name jenkins -d --restart=always -p 8080:8080 -p 5000:5000 -v ${jenkins_home}:/var/jenkins_home --env JAVA_OPTS="-Djava.awt.headless=true -Dhudson.model.DirectoryBrowserSupport.CSP=\"\\\"Sandbox allow-scripts; default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline';\\\"\"" jenkins

docker run --name jenkins -d -u ${uid}:${gid} --restart=always -p 8080:8080 -p 50000:50000 -v ${jenkinsDir}:/var/jenkins_home jenkins

# On first run, there will be a password in the log or in volume
#docker logs jenkins
echo "Initial setup password can be found with:"
echo "cat ${jenkinsDir}/secrets/initialAdminPassword"
