#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-relay.sh | bash

STATIC_IP_ADDRESS=192.168.0.100
ACCEPT_PORT_FROM=20000
ACCEPT_PORT_TO=29999


echo 'Setting up this computer as the "relay"...'


echo "Allowing accesses for all ports $ACCEPT_PORT_FROM to $ACCEPT_PORT_TO..."

IPTABLES_CONFIG=/etc/sysconfig/iptables
IPTABLES_CONFIG_BACKUP=~/iptables.bak.$(date +%Y-%m-%d_%H-%M-%S)
IPTABLES_ACCEPT_LINE="-A INPUT -m state --state NEW -m tcp -p tcp --dport $ACCEPT_PORT_FROM:$ACCEPT_PORT_TO -j ACCEPT"

mv $IPTABLES_CONFIG $IPTABLES_CONFIG_BACKUP
cat $IPTABLES_CONFIG_BACKUP | \
  sed -r -e "s/$IPTABLES_ACCEPT_LINE//" \
         -e "/.+--dport 22 .+$/a $IPTABLES_ACCEPT_LINE" \
  > $IPTABLES_CONFIG

service iptables restart


echo 'Activating port-forwarding from remote computers...'

SSHD_CONFIG=/etc/ssh/sshd_config
SSHD_CONFIG_BACKUP=~/sshd_config.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $SSHD_CONFIG $SSHD_CONFIG_BACKUP
cat $SSHD_CONFIG_BACKUP | \
  sed -r -e 's/^#? *GatewayPorts +no/GatewayPorts clientspecified/' \
  > $SSHD_CONFIG

service sshd restart


echo 'Done.'
