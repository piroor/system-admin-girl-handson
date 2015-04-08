#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/disallow-ssh.sh | bash


echo "Disallowing SSH accesses from public network..."

IPTABLES_CONFIG=/etc/sysconfig/iptables
IPTABLES_CONFIG_BACKUP=~/iptables.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $IPTABLES_CONFIG $IPTABLES_CONFIG_BACKUP
cat $IPTABLES_CONFIG_BACKUP | \
  sed -r -e "s;-s 192.168.0.0/24 ;;" \
         -e "s;(--dport (22|[0-9:]+) );-s 192.168.0.0/24 \1;" \
  > $IPTABLES_CONFIG

service iptables restart


echo 'Done.'
