#!/bin/bash
# Run as root, like:
#   # ~/reset.sh


echo 'Disallowing accesses for large number ports...'
# iptablesの設定を削除して、余計なポートを閉じる。

IPTABLES_CONFIG=/etc/sysconfig/iptables
IPTABLES_CONFIG_BACKUP=~/iptables.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $IPTABLES_CONFIG $IPTABLES_CONFIG_BACKUP
cat $IPTABLES_CONFIG_BACKUP | \
  sed -r -e "/--dport [0-9]+:[0-9]+/d" \
  > $IPTABLES_CONFIG

service iptables restart


echo 'Configuring sshd...'
# リモートフォワードでループバック以外のアドレスでのバインドを禁止する。

SSHD_CONFIG=/etc/ssh/sshd_config
SSHD_CONFIG_BACKUP=~/sshd_config.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $SSHD_CONFIG $SSHD_CONFIG_BACKUP
cat $SSHD_CONFIG_BACKUP | \
  sed -r -e 's/^GatewayPorts (clientspecified|yes)/GatewayPorts no/' \
  > $SSHD_CONFIG

service sshd restart


echo 'Done.'
