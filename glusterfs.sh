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
    # echo "========= 3) CentOS-7 ========="
    echo "======================================================================"
    exit 1
}

# Setting SBIN Path
PATH="/sbin:$PATH"

SUDO() {
    echo "Checking Sudo Command"
    if [ -z $(which sudo)];then
        apt-get update && apt-get install sudo -y
    fi
}

DEBIAN_GLUSTERFS(){
    SUDO
    if [ -z $(which gluster) ];then 
        echo "Gluster is not Installed"
        apt install software-properties-common -y
        apt install glusterfs-server fuse3 -y
        systemctl start glusterd && systemctl enable glusterd
        clear
        echo "All Done Gluster has been installed on OS: $OS - $VERSION"
        echo "See the Gluster Version Information Below"
        echo "Gluster Version: `gluster --version`"
    else 
        echo "Gluster is installed on path: `which gluster`"
        echo "Gluster Version is: `gluster version`"
    fi
}

UBUNTU_GLUSTERFS(){
    SUDO
    if [ -z $(which gluster) ];then 
        echo "Gluster is not Installed"
        add-apt-repository ppa:gluster/glusterfs-10 && apt update
        apt install software-properties-common -y
        apt install glusterfs-server fuse3 -y
        systemctl start glusterd && systemctl enable glusterd

        clear
        echo "All Done Gluster has been installed on OS: $OS - $VERSION"
        echo "See the Gluster Version Information Below"
        echo "Gluster Version: `gluster --version`"
    else 
        echo "Gluster is installed on path: `sudo which gluster`"
        echo "Gluster Version is: `sudo gluster version`"
    fi
}

CENTOS_GLUSTERFS(){
    if [ -z $(which gluster) ];then 
        echo "Gluster is not Installed"

        clear
        echo "All Done Gluster has been installed on OS: $OS - $VERSION"
        echo "See the Gluster Version Information Below"
        echo "Gluster Version: `gluster --version`"
    else 
        echo "Gluster is installed on path: `sudo which gluster`"
        echo "Gluster Version is: `sudo gluster version`"
    fi
}

echo "Checking OS for Installation"

case $OS in
  debian)
    if [ "$VERSION" == "11" ] && [ "$VERSION_CODENAME" == "bullseye" ];then
        echo "OS: $OS"
        echo "Version: $VERSION"    
        clear
        echo "Good to go for Installation of Gluster on this System....!"
        DEBIAN_GLUSTERFS
    else
        DISCLAIMER_OS
    fi
    ;;

  ubuntu)
    if [ "$VERSION" == "20.04" ] && [ "$VERSION_CODENAME" == "focal" ];then
        echo -n "OS: $OS"
        echo -n "Version: $VERSION"
        clear
        echo "Good to go for Installation of Gluster on this System....!"
        UBUNTU_GLUSTERFS
    else
        DISCLAIMER_OS
    fi
    ;;

#   centos)
#     if [ "$VERSION" == "7" ] && [ "$ID" == "centos" ];then
#         echo -n "OS: $OS"
#         echo -n "Version: $VERSION"
#         clear
#         echo "Good to go for Installation of Docker on this System....!"
#         CENTOS_GLUSTERFS
#     else
#         DISCLAIMER_OS
#     fi
#     ;;

  *)
    DISCLAIMER_OS
    ;;
esac
