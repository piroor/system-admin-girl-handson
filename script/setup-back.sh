#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-back.sh | bash

STATIC_IP_ADDRESS=192.168.0.110


echo 'Setting up this computer as the "back"...'


echo 'Downloading scripts to modify network interfaces...'

curl -O https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/activate-eth0.sh
chmod +x ~/activate-eth0.sh

curl -O https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/deactivate-eth0.sh
chmod +x ~/deactivate-eth0.sh


echo 'Creating a new user "user"...'

# rootでログインせずに済むように、作業用のユーザーを作成する。
# 名前は「user」、パスワードも「user」。
# ログイン後に自分でpasswdコマンドを実行してパスワードを変更する事を強く推奨。
useradd user
echo "user" | passwd user --stdin

# 鍵認証できるように、公開鍵の設定をしておく。
mkdir -p ~user/.ssh
cp ~/.ssh/authorized_keys ~user/.ssh/
chown -R user:user ~user/.ssh
chmod 600 ~user/.ssh/authorized_keys


echo 'Activating eth1...'
# インターフェースを有効化するために必要な設定を作成する。
# See: https://www.conoha.jp/guide/guide.php?g=36

# NICのMACアドレスをifconfigの出力から取り出す。
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


echo 'Configuring sshd...'
# SSH経由での直接のrootログインを禁止する。

SSHD_CONFIG=/etc/ssh/sshd_config
SSHD_CONFIG_BACKUP=~/sshd_config.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $SSHD_CONFIG $SSHD_CONFIG_BACKUP
cat $SSHD_CONFIG_BACKUP | \
  sed -r -e 's/^# *PermitRootLogin +yes/PermitRootLogin no/' \
  > $SSHD_CONFIG

service sshd restart


echo 'Disabling canonical plugin of WordPress...'
# WordPressは初期状態で、アクセスされたときのURLを正規化するために、
# あらかじめ決められたURLへリダイレクトするようになっている。
# SSHポートフォワードを使って別のURLで見ると、リダイレクトが無限ループ
# してしまうので、話を簡単にするために正規化の機能自体を無効化する。
# See also: https://ja.forums.wordpress.org/topic/619

WP_CONFIG=/var/www/vhosts/default/wp-settings.php
WP_CONFIG_BACKUP=~/wp-settings.php.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $WP_CONFIG $WP_CONFIG_BACKUP
cat $WP_CONFIG_BACKUP | \
  sed -r -e 's;(^[^/].+canonical.php);// \1;' \
  > $WP_CONFIG


echo 'Done.'
