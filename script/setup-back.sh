#!/bin/bash

echo 'Setting up this computer as the "back"...'

ETH0_MAC_ADDRESS=$(ifconfig eth0 | grep HWaddr | sed -r -e 's/^.* ([0-9A-Z:]+)/\1/')
ETH1_MAC_ADDRESS=$(ifconfig eth1 | grep HWaddr | sed -r -e 's/^.* ([0-9A-Z:]+)/\1/')
ETH0_CONFIG=/etc/sysconfig/network-scripts/ifcfg-eth0
ETH1_CONFIG=/etc/sysconfig/network-scripts/ifcfg-eth1

echo "Detected MAC Address of eth0: $ETH1_MAC_ADDRESS"
echo "Detected MAC Address of eth1: $ETH1_MAC_ADDRESS"

echo 'Configuring eth1...'
echo 'DEVICE="eth1"'                >  $ETH1_CONFIG
echo "HWADDR=\"$ETH1_MAC_ADDRESS\"" >> $ETH1_CONFIG
echo 'BOOTPROTO="static"'           >> $ETH1_CONFIG
echo 'IPADDR="192.168.0.110"'       >> $ETH1_CONFIG
echo 'NETMASK="255.255.255.0"'      >> $ETH1_CONFIG
echo 'NM_CONTROLLED="no"'           >> $ETH1_CONFIG
echo 'TYPE="Ethernet"'              >> $ETH1_CONFIG
echo 'ONBOOT="yes"'                 >> $ETH1_CONFIG

echo 'Restarting interfaces...'
service network restart

echo 'Done.'
