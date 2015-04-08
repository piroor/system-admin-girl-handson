#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-back.sh | bash

STATIC_IP_ADDRESS=192.168.0.110


echo 'Setting up this computer as the "back"...'


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


echo 'Disabling canonical plugin of WordPress...'

WP_CONFIG=/var/www/vhosts/default/wp-settings.php
WP_CONFIG_BACKUP=~/wp-settings.php.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $WP_CONFIG $WP_CONFIG_BACKUP
cat $WP_CONFIG_BACKUP | \
  sed -r -e 's;(^[^/].+canonical.php);// \1;' \
  > $WP_CONFIG


echo 'Done.'
