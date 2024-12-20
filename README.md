This repo includes code and instructions to create a test data centre network using Cumulus routers. The network is created using containerlab and it consists of three Cumulus VX routers connected in a spine-leaf topology (one spine and two leaf).
Cumulus Linux supports routing protocol BGP based on the open-source software FRRouting.
Lab Topology


This graph was made using a command: clab graph -s "0.0.0.0:8080" -t cvx-dcn.clab.yaml Enter the url 'localhost:8080' in your browser to view the topology. You should see a graph similar to the figure above.
Requirements To use this lab, you need to have basic familiarity with Linux (Ubuntu), Docker, and containerlab. This lab was created and tested on an Ubuntu VM.
Environment:
Ubuntu 22.04 Docker v25.03. Follow these instructions to install. Containerlab v0.51.3. Follow these instructions to install. This lab uses the following Docker images:
networkop/cx:5.3.0 networkop/host:ifreload nicolaka/netshoot:latest netenglabs/suzieq:latest (optional) martimy/observium:23.9 (optional) mariadb:10.6.4 (needed for Observium) These images will be downloaded automatically by containerlab when you deploy the lab topology for the first time.
Use the following command to start the lab: sudo containerlab deploy lab_network_setup.clab.yml
To end the lab: sudo containerlab destroy -t lab_network_setup.clab.yml --cleanup
Basic Usage inspect the status of all nodes in the network
sudo containerlab inspect The output should confirm all nodes are running.
╭──────────────────┬────────────────────┬─────────┬───────────────────╮ │ Name │ Kind/Image │ State │ IPv4/6 Address │ ├──────────────────┼────────────────────┼─────────┼───────────────────┤ │ clab-lab-leaf-1 │ cumulus_cvx │ running │ 172.20.20.2 │ │ │ networkop/cx:4.3.0 │ │ 3fff:172:20:20::2 │ ├──────────────────┼────────────────────┼─────────┼───────────────────┤ │ clab-lab-leaf-2 │ cumulus_cvx │ running │ 172.20.20.4 │ │ │ networkop/cx:4.3.0 │ │ 3fff:172:20:20::4 │ ├──────────────────┼────────────────────┼─────────┼───────────────────┤ │ clab-lab-spine-1 │ cumulus_cvx │ running │ 172.20.20.3 │ │ │ networkop/cx:4.3.0 │ │ 3fff:172:20:20::3 │ ╰──────────────────┴────────────────────┴─────────┴───────────────────╯
Confirm that BGP sessions are established among all peers.
docker exec clab-cdc-spine01 vtysh -c "show bgp summary" or using Cumulus commands:
docker exec clab-cdc-spine01 net show bgp summary Note: if you encounter the error "Exiting: failed to connect to any daemons.", wait a couple of minutes.
Show the routes learned from BGP in the routing table. Notices there are two paths to each host.
docker exec clab-cdc-leaf01 vtysh -c "show ip route bgp" or using Cumulus commands:
docker exec clab-cdc-spine01 net show bgp Show all routes
docker exec clab-cdc-spine01 net show route Ping from any one host to another to verify connectivity.
docker exec clab-cdc-server01 ping 10.0.30.101

Router configuration
You can configure the routers using vtysh:
$ docker exec -it clab-cdc-spine01 vtysh
Hello, this is FRRouting (version 7.5+cl5.3.0u0). Copyright 1996-2005 Kunihiro Ishiguro, et al.
spine01# show run Building configuration...
Current configuration: ! frr version 7.5+cl5.3.0u0 frr defaults traditional hostname spine01 service integrated-vtysh-config ! ...
Containerlab Commands Summary Here is a summary of common containerlab commands:
Command Description containerlab deploy -t Deploy a lab from a topology file containerlab destroy -t Destroy a lab from a topology file containerlab inspect -t Inspect the lab status and configuration containerlab graph -t Generate a graphical representation of the lab topology containerlab generate -t Generate a CLOS-based lab topology file containerlab version Show the containerlab version and build information For more details and examples, you can check out the containerlab documentation.
Acknowledgement This lab was originally inspired by the  https://github.com/martimy/clab_cvx_dcn/tree/main
![image](https://github.com/user-attachments/assets/04b11ff2-76bb-4b16-9206-13131a04fe8b)
