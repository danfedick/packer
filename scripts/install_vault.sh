#!/bin/sh -ex

echo "Adding Vault repo"
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

echo "Install Vault binary with apt"
sudo apt-get update
sudo apt-get install -y vault
