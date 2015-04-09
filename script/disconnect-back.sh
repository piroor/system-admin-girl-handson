#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/disconnect-back.sh | bash

echo 'Setting up this computer as the "back"...'


echo 'Deactivating eth0...'
# インターネットに接続されているインターフェースであるeth0を無効化する。
# これにより、このコンピュータは完全にローカルネットワーク内専用になる。
# See also: https://www.conoha.jp/blog/tech/4451.html

ETH0_CONFIG=/etc/sysconfig/network-scripts/ifcfg-eth0
ETH0_CONFIG_BACKUP=~/ifcfg-eth0.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $ETH0_CONFIG $ETH0_CONFIG_BACKUP
cat $ETH0_CONFIG_BACKUP | \
  sed -r -e 's/ONBOOT="yes"/ONBOOT="no"/' \
  > $ETH0_CONFIG

echo 'Restarting interfaces...'
service network restart


echo 'Done.'
