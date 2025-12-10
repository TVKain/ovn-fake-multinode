#!/bin/bash

ovn-nbctl pg-add pg_dgw
ovn-nbctl pg-set-ports pg_dgw S1-R1

ovn-nbctl acl-add pg_dgw from-lport 2000 "inport == @pg_dgw && ip4 && icmp4" allow-related
ovn-nbctl acl-add pg_dgw from-lport 2000 "inport == @pg_dgw && ip4 && udp.dst == 53" allow-related

ovn-nbctl acl-add pg_dgw to-lport 2000 "outport == @pg_dgw && ip4 && tcp.dst == 80" allow-related
ovn-nbctl acl-add pg_dgw to-lport 2000 "outport == @pg_dgw && ip4 && tcp.dst == 443" allow-related
ovn-nbctl acl-add pg_dgw to-lport 2000 "outport == @pg_dgw && ip4 && tcp.dst == 22" allow-related

ovn-nbctl acl-add pg_dgw from-lport 1000 "inport == @pg_dgw && ip4" drop
ovn-nbctl acl-add pg_dgw to-lport 1000 "outport == @pg_dgw && ip4" drop
ovn-nbctl lsp-set-options S1-R1 router-port=R1-S1 enable_router_port_acl=true
