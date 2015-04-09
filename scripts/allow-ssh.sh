#!/bin/bash
# Run as root, like:
#   # ~/allow-ssh.sh


echo "Allowing SSH accesses from public network..."
# iptablesを編集して、ローカルネットワークからの接続のみを
# 受け付けるようにしていた設定を解除する。

IPTABLES_CONFIG=/etc/sysconfig/iptables
IPTABLES_CONFIG_BACKUP=~/iptables.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $IPTABLES_CONFIG $IPTABLES_CONFIG_BACKUP
cat $IPTABLES_CONFIG_BACKUP | \
  sed -r -e "s;-s 192.168.0.0/24 ;;" \
  > $IPTABLES_CONFIG

service iptables restart


echo 'Done.'
