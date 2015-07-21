#!/bin/bash

# Create a Puppet Hiera file for Jenkins module from Jenkins server Plugin directory

cd /var/lib/jenkins/plugins
(echo '---'
echo 'jenkins::configure_firewall: true'
echo 'jenkins::plugin_hash:'
for plugin in $(ls -1 *.jpi | sort); do
  name=$(echo $plugin | cut -d. -f1)
  # Trim ^M off end of version
  version=$(grep '^Plugin-Version:' $name/META-INF/MANIFEST.MF | cut -d: -f2 | cut -c2- | sed 's/.$//')
  echo -e "  $name:\n    version: $version"
done ) > ~/jenkins.yaml

