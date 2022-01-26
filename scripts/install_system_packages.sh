#!/bin/sh -ex
      
echo "Installing System Packages"
sudo apt-get update 
sudo apt-get install -y tee curl wget
