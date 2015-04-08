#!/bin/bash
# Run as root, like:
#   # bash ./activate-eth0.sh


echo 'Activating eth0...'

ETH0_CONFIG=/etc/sysconfig/network-scripts/ifcfg-eth0
ETH0_CONFIG_BACKUP=~/ifcfg-eth0.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $ETH0_CONFIG $ETH0_CONFIG_BACKUP
cat $ETH0_CONFIG_BACKUP | \
  sed -r -e 's/ONBOOT="no"/ONBOOT="yes"/' \
  > $ETH0_CONFIG

echo 'Restarting interfaces...'
service network restart


echo 'Done.'
