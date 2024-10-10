#!/bin/bash

export CENTRAL_IMAGE=tvkain/ovn-multi-node
export CHASSIS_IMAGE=tvkain/ovn-multi-node
export GW_IMAGE=tvkain/ovn-multi-node
export RELAY_IMAGE=tvkain/ovn-multi-node

export RUNC_CMD=docker
export OVN_SRC_PATH=/root/ovn
export OVS_SRC_PATH=/root/ovn/ovs
export OS_IMAGE="ubuntu:22.04"
export OS_BASE="ubuntu"
