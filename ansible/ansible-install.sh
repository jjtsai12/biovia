#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

yum -y install python python-setuptools python-devel gcc openssl-devel wget krb5-devel krb5-libs krb5-workstation
python --version
easy_install pip
pip install paramiko PyYAML Jinja2 httplib2 six
pip install pywinrm
pip install boto boto3 botocore
pip install pywinrm[credssp]
pip install pywinrm[kerberos]


# Install from package
# Ansible 2.4 is now released
pip install ansible

# Install from source

# Install Git
#curl -s https://setup.ius.io/ | sudo bash -
#yum -y install git2u

# Install Ansible from source
#cd ~
#git clone git://github.com/ansible/ansible.git --recursive
#cd ~/ansible
#pip install -r ./requirements.txt

# Source ansible environment
#source ~/ansible/hacking/env-setup -q

ansible --version
