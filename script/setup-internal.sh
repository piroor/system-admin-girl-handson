#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-internal.sh | bash

STATIC_IP_ADDRESS=10.0.0.100


echo 'Setting up this computer as the "internal"...'


echo 'Downloading script for reconnection...'

curl -o ~/activate-eth0.sh https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/activate-eth0.sh
chmod +x ~/activate-eth0.sh


echo 'Deactivating eth0...'

ETH0_MAC_ADDRESS=$(ifconfig eth0 | grep HWaddr | sed -r -e 's/^.* ([0-9A-Z:]+)/\1/')

echo "Detected MAC Address of eth0: $ETH0_MAC_ADDRESS"

ETH0_CONFIG=/etc/sysconfig/network-scripts/ifcfg-eth0
ETH0_CONFIG_BACKUP=~/ifcfg-eth0.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $ETH0_CONFIG $ETH0_CONFIG_BACKUP
cat $ETH0_CONFIG_BACKUP | \
  sed -r -e 's/ONBOOT="yes"/ONBOOT="no"/' \
  > $ETH0_CONFIG

echo 'Activating eth1...'

ETH1_MAC_ADDRESS=$(ifconfig eth1 | grep HWaddr | sed -r -e 's/^.* ([0-9A-Z:]+)/\1/')

echo "Detected MAC Address of eth1: $ETH1_MAC_ADDRESS"

ETH1_CONFIG=/etc/sysconfig/network-scripts/ifcfg-eth1
echo 'DEVICE="eth1"'                 >  $ETH1_CONFIG
echo "HWADDR=\"$ETH1_MAC_ADDRESS\""  >> $ETH1_CONFIG
echo 'BOOTPROTO="static"'            >> $ETH1_CONFIG
echo "IPADDR=\"$STATIC_IP_ADDRESS\"" >> $ETH1_CONFIG
echo 'NETMASK="255.255.255.0"'       >> $ETH1_CONFIG
echo 'NM_CONTROLLED="no"'            >> $ETH1_CONFIG
echo 'TYPE="Ethernet"'               >> $ETH1_CONFIG
echo 'ONBOOT="yes"'                  >> $ETH1_CONFIG

echo 'Restarting interfaces...'
service network restart


echo 'Done.'
