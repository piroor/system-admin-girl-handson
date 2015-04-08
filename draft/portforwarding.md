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

サーバを起動して、ログインする。
以下の通りセットアップスクリプトを実行する。

~~~
# curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-front.sh | bash
~~~

これにより、以下の設定が施される。

 * eth1を有効化し、192.168.0.100を固定割り当て
 * ループバックアドレス以外のバインドアドレスによるリモートフォワードを許可
 * 20000～29999番のポートへの外部からの接続を許可


# 社内接続専用のWordPressサーバのセットアップ

既定の設定で、イメージを「CentOS + nginx + wordpress」にしてVPSを作成。
ラベルは「back」とする。
192.168.0.0/24のローカルネットワークに接続するインターフェースを追加する。

サーバを起動して、ログインする。
以下の通りセットアップスクリプトを実行する。

~~~
# curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-front.sh | bash
~~~

これにより、以下の設定が施される。

 * eth1を有効化し、192.168.0.110を固定割り当て
 * eth0を無効化（インターネット経由ではアクセスできないようになる）



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





# SSHポートフォワード（逆方向）で、frontの20022番ポートを手元のPCの22番ポートに転送する

※なぜ20022か？：SSHの既定のポート番号が22なので、それに20000を足している。

~~~
$ ssh root@203.0.113.1 -i .ssh/conoha -R 192.168.0.100:20022:localhost:22
~~~

これで、backからfrontを経由して手元のPCにSSH接続できるようになっている。
（sshdが起動している、パスワード認証でSSH接続できるなど、条件が整っていれば。）

~~~
# ssh username@192.168.0.100
~~~

RはRemoteForwardの意味。RemoteからLocalへ逆方向に転送するので、RemoteForward。




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
