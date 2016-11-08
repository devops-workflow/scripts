
# https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin
#
dirSlave='/data/JenkinsSlave'
swarmVersion='2.2'
swarmFile="swarm-client-${swarmVersion}-jar-with-dependencies.jar"
swarmURL="https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${swarmVersion}/${swarmFile}"
swarmLink='swarm-client-jar-with-dependencies.jar'
swarmUser='jenkins-slave'
swarmGroup='jenkins'
# Use if autodiscovery doesn't work
jenkinsMasterURL='http://snemetz-5810:8080/'
###
### Setup Slave
###
# create user and group
# getent returns line from file
if [ ! $(getent group ${swarmGroup}) ]; then
  groupadd ${swarmGroup}
fi
# id -u ${swarmUser} # then test $?
getent passwd ${swarmUser} > /dev/null
if [ $? -ne 0 ]; then
  useradd -d ${dirSlave} -g ${swarmGroup} -c 'Jenkins Slave' -s /bin/bash -m ${swarmUser}
fi
# Should be redundant, but make sure
if [ ! -d ${dirSlave} ]; then
  mkdir -p ${dirSlave}
  chown -R ${swarmUser}:${swarmGroup} ${dirSlave}
fi
# Switch user at ths point?
# DL CLI agent
if [ ! -f ${dirSlave}/${swarmFile} ]; then
  wget -O ${dirSlave}/${swarmFile} ${swarmURL}
  ln -s ${dirSlave}/${swarmFile} ${dirSlave}/${swarmLink}
  chown ${swarmUser}:${swarmGroup} ${dirSlave}/${swarmFile}
fi
###
### Start agent
###
# TODO: Dynamically create labels for tools
# TODO: build optional args
# Jenkins master need to expose port: UDP
user='slave'
export access='51Av3!'
#java -jar ${swarmLink} -master ${jenkinsMasterURL} > log 2>&1&
#java -jar ${swarmLink} -help
#-description ${HOST}
#-executors <# cpu - 2>
#-fsroot <dir for Jenkins files>
#-labels 'x y z'
#-labelsFile
#-master ${jenkinsMasterURL}
#-name ${HOST}
#-username
#-passwordEnvVariable ${access}
#-showHostName
