#!/bin/bash

# Script for install docker with last version in Ubuntu distro with apt package manager ( mb his could work on other distro with apt PM )

RM_PKGS=(
    docker.io 
    docker-doc
    docker-compose
    docker-compose-v2 
    podman-docker 
    containerd 
    runc
)

INSTALL_PKGS=(
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
)

DEPS_PKGS=(
    ca-certificates
    curl
)


for PKG in "${RM_PKGS[@]}"; do
    echo "===> delete package: $PKG" 
    sudo apt remove -y "$PKG"
done

sudo apt-get -y update 2>&1 


for PKG in "${DEPS_PKGS[@]}"; do
    echo "===> install pkg: $PKG"
    sudo apt install -y "$PKG"
done 

sudo install -m 0755 -d /etc/apt/keyrings
echo "===> add docker repo key"
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 
sudo chmod a+r /etc/apt/keyrings/docker.asc


echo "===> add docker repo"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "===> update packages"

sudo apt-get -y update 

for PKG in "${INSTALL_PKGS[@]}"; do
    echo "===> install pkg: $PKG"
    sudo apt install -y "$PKG"
done

echo "===> add docker group" 
sudo addgroup --system docker 
newgrp docker

echo "===> enable docker service"

sudo systemctl restart docker 
sudo systemctl enable docker

echo "===> add user"

sudo adduser $USER docker 
sudo usermod -aG docker $USER

echo "===> install docker success"