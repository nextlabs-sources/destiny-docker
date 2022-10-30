#!/usr/bin/env bash
ipAddress=$1

yum -y install epel-release
yum -y install unzip
yum -y install jq
yum -y install bind-utils

# install guest additions so that mounting will work
yum -y groupinstall "Development Tools" 
yum -y install kernel-devel 
yum -y install dkms

yum -y install docker
#yum -y distro-sync

