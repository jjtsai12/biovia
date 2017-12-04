#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# ./enable-ius.sh
# Delete old versions of git, on RHEL 7.4 it's 1.8.3 and there's no newer version in the RHEL repo
yum -y erase git
# Install a newer version of Git from ius
curl -s https://raw.githubusercontent.com/iuscommunity/automation-examples/bash/enable-ius.sh | bash -
yum -y install git2u
git --version