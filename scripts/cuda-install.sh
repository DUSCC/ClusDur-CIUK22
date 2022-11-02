#!/bin/bash
#TODO: add how to install CUDA drivers
sudo dnf groupinstall "Development Tools"
wget https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/drpms/blis-0.4.1-2.el7_0.6.0-4.el7.aarch64.drpm
rpm -Uvh blis-0.4.1-2.el7_0.6.0-4.el7.aarch64.drpm 
sudo yum install deltarpm -y
sudo yum install --enablerepo=extras epel-release
sudo yum remove ipa-common ipa-common-client ipa-client
sudo yum install kernel-debug-devel dkms
sudo yum --nobest -y install cuda
export PATH=/usr/local/cuda-11.0/bin:$PATH