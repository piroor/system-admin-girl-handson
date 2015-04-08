# ローカルネットワークの用意

192.168.0.0/24のローカルネットワークを作成する。


# SSH Keyの用意

鍵ペアを作成し、秘密鍵をダウンロードする。
~/.ssh/conoha
の位置に置き、
chmod 600 ~/.ssh/conoha
に設定する。


# 踏み台にするサーバのセットアップ

既定の設定でVPSを作成。
ラベルは「front」とする。
グローバルIPは203.0.113.1とする。

一旦終了して、192.168.0.0/24のローカルネットワークに接続するインターフェースを追加する。
MACアドレスを控えておく（fa:16:3e:78:01:51とする）。

サーバを起動して、ログインする。
以下の通りローカルネットワークを設定し、192.168.0.100を割り当てる。

~~~
# vim /etc/sysconfig/network-scripts/ifcfg-eth1
~~~

~~~
DEVICE="eth1"
HWADDR="fa:16:3e:78:01:51"
BOOTPROTO="static"
IPADDR="192.168.0.100"
NETMASK="255.255.255.0"
NM_CONTROLLED="no"
TYPE="Ethernet"
ONBOOT="yes"
~~~

ネットワークを再起動する。

~~~
# service network restart
~~~



# 社内接続専用のWordPressサーバのセットアップ

既定の設定で、イメージを「CentOS + nginx + wordpress」にしてVPSを作成。
ラベルは「wordpress」とする。
192.168.0.0/24のローカルネットワークに接続するインターフェースを追加する。
MACアドレスを控えておく（fa:16:3e:78:01:61とする）。


サーバを起動して、ログインする。
以下の通りローカルネットワークを設定し、192.168.0.110を割り当てる。

~~~
# vim /etc/sysconfig/network-scripts/ifcfg-eth1
~~~

~~~
DEVICE="eth1"
HWADDR="fa:16:3e:78:01:61"
BOOTPROTO="static"
IPADDR="192.168.0.110"
NETMASK="255.255.255.0"
NM_CONTROLLED="no"
TYPE="Ethernet"
ONBOOT="yes"
~~~

また、eth0を無効化する

~~~
# vim /etc/sysconfig/network-scripts/ifcfg-eth0
~~~

~~~
ONBOOT="no" （ここだけ書き換える）
~~~

ネットワークを再起動する。

~~~
# service network restart
~~~

これで、インターネット経由ではアクセスできないようになる。




# SSHポートフォワード（順方向）で、手元のPCの10080番ポートを192.168.0.110の80番ポートに転送する

※なぜ10080か？：転送先のポート番号が分かりやすいように、10000とか20000とかの大きな値を足しただけのポート番号を使う事が多い。本来は何でも構わない。

~~~
$ ssh root@203.0.113.1 -i .ssh/conoha -L 10080:192.168.0.110:80
~~~

これで、手元のPCの10080番ポートからwordpressにHTTP接続できる。
LはLocalForwardの意味。LocalからRemoteへ転送するので、LocalFowrard。

~~~
$ curl -L "http://localhost:10080/"
~~~

ブラウザでも見える。
ただし、WordPressの初期状態だとリダイレクトで
http://localhost/wp-admin/install.php
に行ってしまうので、ポート番号の指定を足して
http://localhost:10080/wp-admin/install.php
として再読み込みする必要がある。

手元のPCを踏み台にして他のPCから接続する場合は、sshに-gオプションが必要となる。

~~~
$ curl -L "http://localhost:10080/" -g
~~~

手元のPCのIPアドレスが192.168.1.10であるならば、他のPCから
http://192.168.1.10:10080/wp-admin/install.php
にアクセスすれば、WordPressの画面を見る事ができる。




# SSHポートフォワード（順方向）で、手元のPCの10022番ポートを192.168.0.110の22番ポートに転送する

鍵認証を使っていない場合には、この方法の出番はなさげ。

~~~
$ ssh root@203.0.113.1 -i .ssh/conoha -L 10022:192.168.0.110:22
~~~

これで、手元のPCの10022番ポートからwordpressにSSH接続できる。

~~~
ssh root@localhost -i .ssh/conoha -p 10022
~~~




# SSHポートフォワード（逆方向）で、frontの20102番ポートを手元のPCの10102番ポートに転送する

※なぜ20102か？：rabbirackの既定のポート番号が10102なので、それに10000を足している。

http://rabbit-shocker.org/ja/rabbirack/
これを手元のPCで動かしている時に、インターネットにしか繋がっていない携帯端末で手元のPCのRabbitを操作する。

~~~
$ ssh root@203.0.113.1 -i .ssh/conoha -R 203.0.113.1:20102:localhost:10102
~~~

あるいは

~~~
$ ssh root@203.0.113.1 -i .ssh/conoha -R 0.0.0.0:20102:localhost:10102
~~~

RはRemoteForwardの意味。RemoteからLocalへ逆方向に転送するので、RemoteForward。


これをやるためには、以下の設定も変える必要がある。

## 20102番ポートの開放

初期状態ではiptablesで22番ポート等の一部のポートだけが開放されている。
iptablesの設定を変えて、20102番ポートも開放してやらないといけない。

~~~
# vim /etc/sysconfig/iptables
~~~

面倒なので20000から29999までのポートをまとめて解放する。
（20000～29999をリモートフォワード用によく使う、と仮定する）

~~~
...
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 20000:29999 -j ACCEPT # この行を追加
...
~~~

iptablesを再起動する。

~~~
# service iptables restart
~~~

## ループバックアドレス以外のバインドアドレスによるリモートフォワードの許可

sshdの設定を変える必要がある。
初期状態では、localhost:20102 としてアクセスされた時しかリモートフォワードされない。

~~~
# vim /etc/ssh/sshd_config
~~~

で設定ファイルを開いて

~~~
GatewayPorts clientspecified
~~~

という設定を書き足す（既にある場合は、値を書き換える）。
その後、sshdを再起動する。

~~~
# service sshd restart
~~~

これで、203.0.113.1:20102 としてアクセスされた時でもリモートフォワードされる。

