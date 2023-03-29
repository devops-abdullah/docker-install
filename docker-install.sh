#!/bin/bash

set -e
#set -x

OS=`cat /etc/os-release | grep ^ID | head -n 1 | cut -d "=" -f2 | tr -d '"'`
VERSION=`cat /etc/os-release | grep ^VERSION_ID | head -n 1 | cut -d '"' -f2`
VERSION_CODENAME=`cat /etc/os-release | grep ^VERSION_CODENAME | head -n 1 | cut -d '=' -f2`
ID=`cat /etc/os-release | grep ^ID= | head -n 1 | cut -d '=' -f2 | tr -d '"'`

DISCLAIMER_OS() {
    clear
    echo "======================================================================"
    echo "Unknown OS release This script is only compatible with below list OS"
    echo "========= 1) Debian-11 Bullseye ========="
    echo "========= 2) Ubuntu-20.04 Focal ========="
    echo "========= 3) CentOS-7 ========="
    echo "======================================================================"
    exit 1
}


SUDO() {
    echo "Checking Sudo Command"
    if [ -z $(which sudo)];then
        apt-get update && apt-get install sudo -y
    fi
}


DEBIAN_DOCKER(){
    SUDO
    if [ -z $(which docker) ];then 
        echo "Docker is not Installed"
        # updating the APT-GET and Installing required Packages
        sudo apt-get update && \
        sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        git \
        lsb-release -y

        # Setting up the GPG key
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        # Setting up the repo for Docker CE Stable Latest release
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Updating the Repo Data
        sudo apt-get update
        ################## incase of Error during apt-get update 
        #### sudo chmod a+r /etc/apt/keyrings/docker.gpg
        #### sudo apt-get update
        
        # Installing Docker and Docker Compose for 
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        
        clear
        echo "All Done Docker has been installed on OS: $OS - $VERSION"
        echo "See the Docker Version Information Below"
        echo "Docker Version: `docker --version`"
    else 
        echo "Docker is installed on path: `which docker`"
        echo "Docker Version is: `docker version`"
    fi
}

UBUNTU_DOCKER(){
    SUDO
    if [ -z $(which docker) ];then 
        echo "Docker is not Installed"
        # updating the APT-GET and Installing required Packages
        sudo apt-get update && \
        sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        git \
        lsb-release -y

        # Setting up the GPG key
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        # Setting up the repo for Docker CE Stable Latest release
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Updating the Repo Data
        sudo apt-get update
        ################## incase of Error during apt-get update 
        #### sudo chmod a+r /etc/apt/keyrings/docker.gpg
        #### sudo apt-get update
        
        # Installing Docker and Docker Compose for 
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        
        clear
        echo "All Done Docker has been installed on OS: $OS - $VERSION"
        echo "See the Docker Version Information Below"
        echo "Docker Version: `docker --version`"
    else 
        echo "Docker is installed on path: `sudo which docker`"
        echo "Docker Version is: `sudo docker version`"
    fi
}

CENTOS_DOCKER(){
    if [ -z $(which docker) ];then 
        echo "Docker is not Installed"
        sudo yum install -y yum-utils git
        sudo yum-config-manager \
            --add-repo \
            https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce-23.0.0 docker-ce-cli-23.0.0 containerd.io-1.6.16 docker-compose-plugin-2.15.1
        sudo systemctl enable docker
        sudo systemctl start docker
        clear
        echo "All Done Docker has been installed on OS: $OS - $VERSION"
        echo "See the Docker Version Information Below"
        echo "Docker Version: `docker --version`"
    else 
        echo "Docker is installed on path: `sudo which docker`"
        echo "Docker Version is: `sudo docker version`"
    fi
}

echo "Checking OS for Installation"

case $OS in
  debian)
    if [ "$VERSION" == "11" ] && [ "$VERSION_CODENAME" == "bullseye" ];then
        echo "OS: $OS"
        echo "Version: $VERSION"    
        clear
        echo "Good to go for Installation of Docker on this System....!"
        DEBIAN_DOCKER
    else
        DISCLAIMER_OS
    fi
    ;;

  ubuntu)
    if [ "$VERSION" == "20.04" ] && [ "$VERSION_CODENAME" == "focal" ];then
        echo -n "OS: $OS"
        echo -n "Version: $VERSION"
        clear
        echo "Good to go for Installation of Docker on this System....!"
        UBUNTU_DOCKER
    
    elif [ "$VERSION" == "22.04" ] && [ "$VERSION_CODENAME" == "jammy" ];then
        echo -n "OS: $OS"
        echo -n "Version: $VERSION"
        clear
        echo "Good to go for Installation of Docker on this System....!"
        UBUNTU_DOCKER

    elif [ "$VERSION" == "22.10" ] && [ "$VERSION_CODENAME" == "Kinetic" ];then
        echo -n "OS: $OS"
        echo -n "Version: $VERSION"
        clear
        echo "Good to go for Installation of Docker on this System....!"
        UBUNTU_DOCKER
    else
        DISCLAIMER_OS
    fi
    ;;

  centos)
    if [ "$VERSION" == "7" ] && [ "$ID" == "centos" ];then
        echo -n "OS: $OS"
        echo -n "Version: $VERSION"
        clear
        echo "Good to go for Installation of Docker on this System....!"
        CENTOS_DOCKER
    else
        DISCLAIMER_OS
    fi
    ;;

  *)
    DISCLAIMER_OS
    ;;
esac
