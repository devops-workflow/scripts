#!/bin/bash

# Get list of Jenkins plugins currently installed

user=$1
pswd=$2

curl -s -k "http://${user}:${pswd}@localhost:8080/pluginManager/api/json?depth=1" \
	  | jq -r '.plugins[].shortName' | tee plugins.txt


