#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-plain-relay.sh | bash


echo 'Setting up this computer as the "plain-relay"...'


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


echo 'Configuring sshd...'
# SSH経由での直接のrootログインを禁止する。
# パスワード認証を許可する。（話を簡単にするため）

SSHD_CONFIG=/etc/ssh/sshd_config
SSHD_CONFIG_BACKUP=~/sshd_config.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $SSHD_CONFIG $SSHD_CONFIG_BACKUP
cat $SSHD_CONFIG_BACKUP | \
  sed -r -e 's/^# *PermitRootLogin +yes/PermitRootLogin no/' \
         -e 's/^( *PasswordAuthentication +no)/#\1/' \
         -e 's/^#( *PasswordAuthentication +yes)/\1/' \
  > $SSHD_CONFIG

service sshd restart


echo 'Done.'
