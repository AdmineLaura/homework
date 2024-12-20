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
  


## Step-by-step instruction on how to install the lab

1. Download repo files to the Ubuntu server and place them to users home directory.
2. run script 1_install_components.sh
3. run script 2_setup_containerlab_lab.sh
4. run script 3_install_ssh_keys_to_clients.sh
5. run script 4_run_ansible_homework.sh


6. run script check_bgp_status.sh to check if bgp sessions are established.
   

To delete the lab: 
sudo containerlab destroy -t lab_network_setup.clab.yml --cleanup


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


Confirm that BGP sessions are established among all peers.
```
docker exec clab-hostinger-homework-spine01 vtysh -c "show bgp summary"
```
or using Cumulus commands:
```
docker exec clab-hostinger-homework-spine01 net show bgp summary
```


Show the routes learned from BGP in the routing table. Notices there are two paths to each host.
```
docker exec clab-hostinger-homework-leaf01 vtysh -c "show ip route bgp"
```
or using Cumulus commands:
```
docker exec clab-hostinger-homework-spine01 net show bgp Show all routes
```
```
docker exec clab-hostinger-homework-spine01 net
```
