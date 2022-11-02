#!/bin/bash

ansible-playbook -i $1 --private-key /home/team2/.ssh/alSSHflight.pem ./benchmarking.yaml
