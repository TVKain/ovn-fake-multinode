#!/bin/bash

name=VM
iface_id=S2-VM
mac="40:50:00:00:00:03"
ip=192.168.31.100/24

# Create the namespace
ip netns add $name

# Create veth pair
ip link add $name-p type veth peer name $name

# Move the namespace side into the namespace
ip link set $name netns $name

# Bring up host side
ip link set $name-p up

# Add host side to OVS bridge
ovs-vsctl add-port br-int $name-p
ovs-vsctl set Interface $name-p external_ids:iface-id=$iface_id

# Configure the namespace side
ip netns exec $name ip link set lo up
ip netns exec $name ip link set $name address $mac
ip netns exec $name ip addr add $ip dev $name
ip netns exec $name ip link set $name up
