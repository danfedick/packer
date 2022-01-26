#!/bin/sh -ex

echo "Adding Vault repo"
sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"


echo "Install Vault binary with apt"
sudo apt update
sudo apt install vault -y 

echo "Completed Vaultu Installation"