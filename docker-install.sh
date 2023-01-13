#!/bin/bash

set -e
#set -x

OS=`cat /etc/os-release | grep ^ID | head -n 1 | cut -d "=" -f2`
VERSION=`cat /etc/os-release | grep ^VERSION_ID | head -n 1 | cut -d '"' -f2`

DISCLAIMER_OS() {
    clear
    echo "======================================================================"
    echo "Unknown OS release This script is only compatible with below list OS"
    echo "========= 1) Debian-11 Bullseye ========="
    echo "========= 2) Ubuntu-20.04 ========="
    echo "======================================================================"
    exit 1
}

DEBIAN_DOCKER(){
    # updating the APT-GET and Installing required Packages
    apt-get update && \
    apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

    # Setting up the GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Setting up the repo for Docker CE Stable Latest release
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Updating the Repo Data
    apt-get update

    # Installing Docker and Docker Compose for 
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    clear
    echo "All Done Docker has been installed on OS: $OS - $VERSION"
    echo "See the Docker Version Information Below"
    echo "Docker Version: `docker --version`"
}
echo "Checking OS for Installation"

case $OS in
  debian)
    if [ "$VERSION" == "11" ];then
        echo "OS: $OS"
        echo "Version: $VERSION"        
    else
        DISCLAIMER_OS
    fi
    ;;

  ubuntu)
    if [ "$VERSION" == "20.04" ];then
        echo -n "OS: $OS"
        echo -n "Version: $VERSION"        
    else
        DISCLAIMER_OS
    fi
    ;;

  *)
    DISCLAIMER_OS
    ;;
esac
