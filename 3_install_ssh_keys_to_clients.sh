#!/bin/bash

#Generate SSH key
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y

#Copy ssh key to ansible managed hosts

ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.20.20.2
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.20.20.3
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.20.20.4
