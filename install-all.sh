#!/bin/bash

set -e

bash <(curl -s https://raw.githubusercontent.com/devops-abdullah/docker-install/main/docker-install.sh)

bash <(curl -s https://raw.githubusercontent.com/devops-abdullah/docker-install/main/glusterfs-install.sh)

