#!/bin/sh
#  Name: system_setup.sh
#  Author: Dan Fedick
#######################################
# set -x # Uncomment to Debug
      
echo "Installing Docker-Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Adding Vault repo"
sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install vault 
sudo apt-get update && sudo apt-get install consul
sudo apt-get update && sudo apt-get install nomad 