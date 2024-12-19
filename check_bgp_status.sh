#!/bin/bash

docker exec clab-hostinger-homework-spine01  vtysh -c "show bgp summary"
docker exec clab-hostinger-homework-leaf01  vtysh -c "show bgp summary"
docker exec clab-hostinger-homework-leaf02  vtysh -c "show bgp summary"

