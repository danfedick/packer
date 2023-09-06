#!/bin/sh
#  Name: system_setup.sh
#  Author: Dan Fedick
#######################################
# set -x # Uncomment to Debug

sudo apt update && sudo apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update

install() {
  sudo apt-get install $1
  if [ $? -ne 0 ]
  then
    error "$1 was not installed correctly"
    exit 7
  else
    echo "$1 was installed successfully"
    exit 0
  fi
}

echo "Installing Docker-Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

for app in "vault consul jq wget curl" 
do
  install $app
done
