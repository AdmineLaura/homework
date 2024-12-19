#!/bin/bash

# install containerlab
curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"
# install python pip
sudo apt install python3-pip -y
# install Ansible 8.5.0
python3 -m pip install ansible==8.5.0 --user

#deploy homelab 

sudo containerlab deploy hostinger-lab.clab.yml

#Generate SSH key
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y
#Copy ssh key to ansible managed hosts
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.20.20.2
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.20.20.3
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.20.20.4
