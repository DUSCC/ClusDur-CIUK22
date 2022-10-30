#!/bin/bash

export IP=10.151.15.164
ansible-playbook -i $IP, ./benchmarking.yaml 
scp -r centos@$IP:/home/centos/results/ ./
