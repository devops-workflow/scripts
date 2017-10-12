#!/bin/bash
#
# Install Lynis securoty auditing tool
#   https://cisofy.com/lynis
#

if [ -f /etc/os-release ]; then
  OS=$(grep -E ^ID= /etc/os-release | cut -d= -f2)
  # TODO: strip quotes
elif [ -f /etc/lsb-release ]; then
  OS=$(grep DISTRIB_ID /etc/lsb-release | cut -d= -f2)
  Release=$(grep DISTRIB_RELEASE /etc/lsb-release | cut -d= -f2)
  CodeName=$(grep DISTRIB_CODENAME /etc/lsb-release | cut -d= -f2)
fi
if [ "$OS" == 'amzn' ]; then
#if [ "$OS" == 'RHEL??' ]; then
  ###
  ### RHEL, CentOS, Amazon Linux
  ###
  yum -y update ca-certificates curl nss openssl
  cat <<YUM >/etc/yum.repos.d/cisofy-lynis.repo
[lynis]
name=CISOfy Software - Lynis package
baseurl=https://packages.cisofy.com/community/lynis/rpm/
enabled=1
gpgkey=https://packages.cisofy.com/keys/cisofy-software-rpms-public.key
gpgcheck=1
priority=1
YUM
  yum makecache fast
  yum -y install lynis
fi

if [ "$OS" == 'Ubuntu' ]; then
  ###
  ### Ubuntu setup
  ###
  # import key
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C80E383C3DE9F082E01391A0366C67DE91CA5D5F
  # or wget -O - http://packages.cisofy.com/keys/cisofy-software-public.key | apt-key add -
  # Disable language translations
  echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99disable-translations
  # Add repository
  echo "deb https://packages.cisofy.com/community/lynis/deb/ ${CodeName} main" > /etc/apt/sources.list.d/cisofy-lynis.list
  # Install dependencies
  apt-get install apt-transport-https
  # Install lynis
  apt-get update
  apt-get install -y lynis
  # TODO: Install plugins
  #pluginDir=$(lynis show plugindir)
  #if [ -d "${pluginDir}" ]; then
  #  # dl plugins (put in artifactory), tar xzf, put in plugins dir
  #  pushd ${pluginDir}/..
  #  # dl plugins
  #  tar xzf $plugins
  #  chown -R root:root plugins
  #  chmod 0644 plugins/*
  #  rm $plugins
  #  # TODO: edit profile to enable plugins - if needed
  #   /etc/lynis/default.prf edit or add new profile
  #   $(lynis show profiles)
  #  popd
  #fi
fi
lynis show version
