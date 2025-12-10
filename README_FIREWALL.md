# Firewall Testing

## Mechanism
- Emulate OVN nodes with containers
- Emulate switching with OVS 
- Emulate vm with nested containers
- Emulate PUBLIC with containers

## OVN setup TOPO

Bridges

|Bridge|Purpose|
|------|-------|
|docker0 or podmancni0|Management (Kinda useless)|
|br-ovn|Overlay bridge|
|br-ovn-ext|Physical Network Bridge (For `br-ex*`...)|

Nodes

|Node|Purpose|
|----|-------|
|ovn-central|NB and SB db|
|ovn-gw|Gateway|
|ovn-chassis-1|VM|
|ovn-chassis-2|VM|

Interfaces
|Interface|Bridge|
|-----|------|
|eth0|docker0 or podmancni0|
|eth1|br-ovn|
|eth2|br-ovn-ext|


## OVN Virtual TOPO 

```
PUBLIC ---- S1-(S1-R1) -------- (R1-S1)-R1 -------- S2 ---- VM
R1: dgw port 26.7.2.18, SNAT
S1: localnet 26.7.2.0/24
S2: 192.168.31.0/24 (overlay)
VM: internal 192.168.31.200, floating 26.7.2.2
PUBLIC: 26.7.2.101, 26.7.2.102
```

## How to run this? 

### Requirements
- OVS installed on the physical host
- Docker or Podman installed on the physical host

### Steps

Step 1: Clone `ovn` and `ovs` 
```
git clone --recursive https://github.com/ovn-org/ovn.git  
```

Step 2: Edit `test-firewall/set_path.sh`

- Change path accordingly

Step 3: Set up environment variables
```
source test-firewall/set_path.sh
```

Step 4: Build images
```
./ovn_cluster.sh build
```

Step 5: Start Open vSwitch 
```
/usr/share/openvswitch/scripts/ovs-ctl --system-id=testovn start
```

> If it's already started then stop it with `/usr/share/openvswitch/scripts/ovs-ctl stop` and start it again

Step 6: Start `ovn-fake-multinode`

```
./ovn_cluster.sh start
```

Step 7: Go into `ovn-central` and run `create-topo.sh`

Step 8: Go into `ovn-chassis-1` and run `create-vm.sh` 

Step 9: On the physical host run `create-public-ns.sh <namespace_name> <IP for public>`

Step 10: Test ping from the VM `ping <public ip>`

Step 11: Run `create-firewall.sh`

Step 12: Play around

## Scripts

In `test-firewall` folder

> `create-topo.sh` meant to be run on the `ovn-central` node 
It will create the TOPO above except for the PUBLIC part

> `create-public-ns.sh` is meant to be run on the physical host that is used to set up `ovn-fake-multinode`
This creates a network namespace on the physical host and a pair of veth to connect to `br-ovn-ext` that effectively acts as the PUBLIC internet

> `create-vm.sh` is meant to be run on either `ovn-chassis-1` or `ovn-chassis-2`
This creates a nested network namespace inside of the chassis containers that acts as a VM

> `create-firewall.sh` is meant to be run on the `ovn-gw` node
This creates a port group in OVN and configure it on the (S1-R1) dgw port 

