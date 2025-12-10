#!/bin/sh
# Create namespace

name=$1
ip=$2

sudo ip netns add $name

# Create veth pair
sudo ip link add host-$name type veth peer name $name-host

# Move pub-host into the namespace (THIS is the ns side)
sudo ip link set $name-host netns $name

# Bring up host side
sudo ip link set host-$name up

# Bring up namespace side
sudo ip netns exec $name ip link set $name-host up

# Assign IPs
sudo ip netns exec $name ip addr add $2 dev $name-host

ovs-vsctl add-port br-ovn-ext host-$name
