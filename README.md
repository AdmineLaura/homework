## Test lab overview

This repo includes code and instructions how to create a test network using Cumulus routers.

The test network is created by using containerlab and it consists of three Cumulus VX routers that are connected into a spine-leaf topology (one spine and two leafs).
BGP sessions are configured between spine and each of leaf switches. 


## Lab Topology
<img width="477" alt="Screenshot 2024-12-18 at 21 48 09" src="https://github.com/user-attachments/assets/5308af4c-e031-4a94-a290-404789e7834f" />

This graph was made using a command: 

clab graph -s "0.0.0.0:8080" -t cvx-dcn.clab.yaml Enter the url 'localhost:8080' 

## Requirements To use this lab

To recreate this lab you need to have basic familiarity with Linux (Ubuntu), Docker, and containerlab. This lab was created and tested on an Ubuntu VM.


Environment:
- Ubuntu 22.04 (mano atveju Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-130-generic x86_64)) 
- Docker v25.03.
- Containerlab v0.51.3. 


This lab uses the following Docker images:
- networkop/cx:5.3.0 
- networkop/host:ifreload 
- nicolaka/netshoot:latest 
- netenglabs/suzieq:latest (optional) 
- martimy/observium:23.9 (optional) 
- mariadb:10.6.4 (needed for Observium) 

These images will be downloaded automatically by containerlab when you deploy the lab topology for the first time.


Use the following command to start the lab: 
sudo containerlab deploy lab_network_setup.clab.yml

To end the lab: 
sudo containerlab destroy -t lab_network_setup.clab.yml --cleanup

Basic Usage inspect the status of all nodes in the network:
sudo containerlab inspect 
The output should confirm all nodes are running.
╭──────────────────┬──────────────────────┬──────────────┬───────────────────╮ 
│ Name             │ Kind/Image           │ State        │ IPv4/6 Address    │ 
├──────────────────┼──────────────────────┼──────────────┼───────────────────┤ 
│ clab-lab-leaf-1  │ cumulus_cvx          │ running      │ 172.20.20.2       │
│                  │ networkop/cx:4.3.0   │              │ 3fff:172:20:20::2 │ 
├──────────────────┼──────────────────────┼──────────────┼───────────────────┤ 
│ clab-lab-leaf-2  │ cumulus_cvx          │ running      │ 172.20.20.4       │
│                  │ networkop/cx:4.3.0   │              │ 3fff:172:20:20::4 │
├──────────────────┼──────────────────────┴──────────────┼───────────────────┤ 
│ clab-lab-spine-1 │ cumulus_cvx          │ running      │ 172.20.20.3       │
│                  │ networkop/cx:4.3.0   │              │ 3fff:172:20:20::3 │ 
╰──────────────────┴──────────────────────┴──────────────┴───────────────────╯

Confirm that BGP sessions are established among all peers.
docker exec clab-cdc-spine01 vtysh -c "show bgp summary" or using Cumulus commands:
docker exec clab-cdc-spine01 net show bgp summary 
Note: if you encounter the error "Exiting: failed to connect to any daemons.", wait a couple of minutes.

Show the routes learned from BGP in the routing table. Notices there are two paths to each host.
docker exec clab-cdc-leaf01 vtysh -c "show ip route bgp" or using Cumulus commands:
docker exec clab-cdc-spine01 net show bgp Show all routes
docker exec clab-cdc-spine01 net show route Ping from any one host to another to verify connectivity.
docker exec clab-cdc-server01 ping 10.0.30.101

Router configuration


## Containerlab Commands Summary 



