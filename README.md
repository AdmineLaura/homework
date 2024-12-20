## Test lab overview

This repo includes code and instructions how to create a test network using Cumulus routers.

The test network is created by using containerlab and it consists of three Cumulus VX routers that are connected into a spine-leaf topology (one spine and two leafs).
BGP sessions are configured between spine and each of leaf switches. 


## Requirements to this lab
To recreate this lab you need to have basic familiarity with Linux (Ubuntu), Docker, and containerlab. This lab was created and tested on an Ubuntu VM.

Environment:
- Ubuntu 22.04
- Docker 27.4.1
- Containerlab v0.60.1
- Cumulus_cvx networkop/cx:4.3.0 image

These images (exept Ubuntu) will be downloaded automatically by containerlab when you deploy the lab topology for the first time.  ???????


## Lab Topology
<img width="477" alt="Screenshot 2024-12-18 at 21 48 09" src="https://github.com/user-attachments/assets/5308af4c-e031-4a94-a290-404789e7834f" />

This graph was made using a command: 

```
sudo clab graph -s "0.0.0.0:8080"-t cvx-dcn.clab.yaml
```


## IP Network topology

clab-hostinger-homework-leaf01: 
- AS65201
- 172.20.20.2 mgmt IP address
- 10.1.0.2/24 IP address on interface swp50
- 10.255.255.3/32 lo IP address

clab-hostinger-homework-leaf02: 
- AS65201
- 172.20.20.4 mgmt IP address
- 10.2.0.2/24 IP address on interface swp50
- 10.255.255.3/32 lo IP address

clab-hostinger-homework-spine01: 
- AS65199
- 172.20.20.3 mgmt IP address
- 10.1.0.1/24 IP address on interface swp1
- 10.2.0.1/24 IP address on interface swp2
- 10.255.255.1/32 lo IP address


## BGP configuration

router bgp 65201
    bgp router-id 10.255.255.3
    no bgp ebgp-requires-policy
    neighbor 10.1.0.1 remote-as external

router bgp 65201
    bgp router-id 10.255.255.2
    no bgp ebgp-requires-policy
    neighbor 10.2.0.1 remote-as external

router bgp 65199
    bgp router-id 10.255.255.1
    no bgp ebgp-requires-policy
    neighbor 10.1.0.2 remote-as external
    neighbor 10.2.0.2 remote-as external
  
<br>

## Step-by-step instruction on how to install the lab

<br>

#### 1. Download repo files to the Ubuntu server and place them to users home directory.
```
git clone https://github.com/AdmineLaura/homework.git
```  
<br>

#### 2. Run script "1_install_components.sh"
   _This script will automaticaly install Containerlab, Python packege instaler and Ansible 8.5._
```
./1_install_components.sh
``` 
<br>

#### 3. Run script "2_setup_containerlab_lab.sh"
   _The script will deploy virtual network environment with predefined configuration in "hostinger-lab.clab.yml" file._ 
```
 ./2_setup_containerlab_lab.sh
```
 <br>
 
#### 4. Wait few minutes until container stervices wiill start and then run script "3_install_ssh_keys_to_clients.sh"
   _This script will generate a ssh private and pablic keys, and will try to add public keys to the containers. Script will ask to login into each container. 
   Default logins for containers are root/root. It is highly recomended to change logins after container creation._
```
./3_install_ssh_keys_to_clients.sh
```
<br>

#### 5. Run script "4_run_ansible_homework.sh"
   _The scipt will run ansible-playbook that will create a custom MOTD message display:_
- A welcome message with the server hostname.
- The operating distribution name and version.
- The kernel version.
- Configure FRRouting daemon with BGP sessions between spine and leaf switches.
```
./4_run_ansible_homework.sh
```
<br>

#### 6. Run script check_bgp_status.sh to check if bgp sessions are established.
   _This script will show bgp summary of each container to verity the bpg status_
```
./check_bgp_status.sh
```   
<br>

To delete the lab use the command: 
sudo containerlab destroy -t lab_network_setup.clab.yml --cleanup
<br>
<br>
<br>

## Usefull commands to navigate inside the lab

Basic Usage inspect the status of all nodes in the network:
```
sudo containerlab inspect
```

```
╭─────────────────────────────────┬────────────────────┬─────────┬───────────────────╮
│               Name              │     Kind/Image     │  State  │   IPv4/6 Address  │
├─────────────────────────────────┼────────────────────┼─────────┼───────────────────┤
│ clab-hostinger-homework-leaf01  │ cumulus_cvx        │ running │ 172.20.20.2       │
│                                 │ networkop/cx:4.3.0 │         │ 3fff:172:20:20::3 │
├─────────────────────────────────┼────────────────────┼─────────┼───────────────────┤
│ clab-hostinger-homework-leaf02  │ cumulus_cvx        │ running │ 172.20.20.4       │
│                                 │ networkop/cx:4.3.0 │         │ 3fff:172:20:20::4 │
├─────────────────────────────────┼────────────────────┼─────────┼───────────────────┤
│ clab-hostinger-homework-spine01 │ cumulus_cvx        │ running │ 172.20.20.3       │
│                                 │ networkop/cx:4.3.0 │         │ 3fff:172:20:20::2 │
╰─────────────────────────────────┴────────────────────┴─────────┴───────────────────╯
```
(The output should confirm all nodes are running.)
<br>

Confirm that BGP sessions are established among all peers.
```
docker exec clab-hostinger-homework-spine01 vtysh -c "show bgp summary"
```
or using Cumulus commands:
```
docker exec clab-hostinger-homework-spine01 net show bgp summary
```


Show routes that were learned from BGP in the routing table. 
```
docker exec clab-hostinger-homework-leaf01 vtysh -c "show ip route bgp"     ??????
```
or using Cumulus commands:
```
docker exec clab-hostinger-homework-spine01 net show bgp Show all routes    ?????
```
```
docker exec clab-hostinger-homework-spine01 net   ?????
```
