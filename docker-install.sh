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
