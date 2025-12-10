#!/bin/bash

# Create a logical switch S2
ovn-sbctl ls-add S2

# Add port for VM in logical switch S2
ovn-nbctl lsp-add S2 S2-VM
ovn-nbctl lsp-set-addresses S2-VM "40:50:00:00:00:03 192.168.31.100"

# Create a logical switch S1 connected to the public network
ovn-nbctl ls-add S1
ovn-nbctl lsp-add S1 S1-PUB
ovn-nbctl lsp-set-type S1-PUB localnet
ovn-nbctl lsp-set-addresses S1-PUB unknown
ovn-nbctl lsp-set-options S1-PUB network_name=public

# Create router and attach S2
ovn-nbctl lr-add R1
ovn-nbctl lrp-add R1 R1-S2 00:00:00:00:ff:01 192.168.31.1
ovn-nbctl lsp-add S2 S2-R1
ovn-nbctl lsp-set-type S2-R1 router
ovn-nbctl lsp-set-addresses S2-R1 router
ovn-nbctl lsp-set-options S2-R1 router-port=R1-S2

# Attach S1 to router
ovn-nbctl lrp-add R1 R1-S1 00:00:20:20:12:13 26.7.2.18
ovn-nbctl lsp-add S1 S1-R1
ovn-nbctl lsp-set-type S1-R1 router
ovn-nbcll lsp-set-addresses S1-R1 router
ovn-nbctl lsp-set-options S1-R1 router-port=R1-S1
