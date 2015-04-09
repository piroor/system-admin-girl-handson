# シス管系女子 ハンズオン

subtitle
:   試して覚えよう！ SSHポートフォワーディング

author
:   Piro / 結城洋志

institution
:   株式会社クリアコード

allotted_time
:   60m




# 使用するサーバーを準備しよう

踏み台になるサーバーと
社内専用Webサーバーを用意しよう

# 目指すゴール

（ネットワーク構成図）

# ローカルネットワークの作成

（スクリーンショット）

# VPSの作成（踏み台）

（スクリーンショット）

 * 既定の設定

# VPSの作成（社内専用サーバー）

（スクリーンショット）

 * CentOS + nginx + wordpress

# VPSの設定（踏み台）

（スクリーンショット）

 * ローカルネットワークに接続
 * セットアップ用スクリプトを実行

~~~
root@front# curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-front.sh | bash
root@front# su user
user@front$ passwd
~~~

IPアドレスは203.0.113.1と仮定

# VPSの設定（社内専用サーバー）

（スクリーンショット）

 * ローカルネットワークに接続
 * セットアップ用スクリプトを実行

~~~
root@back# curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/script/setup-back.sh | bash
root@back# su user
user@back$ passwd
~~~

IPアドレスは203.0.113.2と仮定

# 動作を確かめてみよう

http://203.0.113.2/

（スクリーンショット）

 * WordPressの初期画面が表示されるか？
 * ささっと初期設定を済ませてしまう

# 社内専用サーバーをインターネットから切り離そう

 * 設定変更用スクリプトを実行

~~~
# ~/deactivate-eth0.sh
~~~

# 準備完了

（ネットワーク構成図）




# SSHポートフォワーディングを試してみよう

# ポートフォワーディングとは？

（概念図）


# Case0: ポートフォワードが必要ないケース

# Case0-1: 社外にあるPCから社内専用のサーバーにSSH接続したい

（ネットワーク構成図）


手元のPC：

~~~
$ ssh user@203.0.113.1
~~~

ログイン先の踏み台サーバー（front）：

~~~
user@front$ ssh user@192.168.0.110
~~~

（概念図）


# Case0-2: 社外にあるPCから社内専用のサーバーにSCPでファイルをアップロードしたい（または、ファイルをダウンロードしたい）

（ネットワーク構成図）

手元のPC：

~~~
$ echo "Hello!" >  /tmp/localfile
$ scp /tmp/localfile user@203.0.113.1:/tmp/uploadedfile
$ ssh user@203.0.113.1
user@front$ scp /tmp/uploadedfile user@192.168.0.110:/tmp/uploadedfile
~~~

（概念図）

一旦リモートのサーバに置いてから、もう1度コピーすることになる。



# Case1: ローカルフォワード（順方向のポートフォワード）

（概念図）


# Case1-1: 社外にあるPCから社内専用のサーバーにSCPで直接ファイルをアップロードしたい（または、ファイルをダウンロードしたい）

（ネットワーク構成図）

手元のPC：

~~~
$ ssh user@203.0.113.1 -L 10022:192.168.0.110:22
~~~

手元のPCの別コンソール：

~~~
$ scp -P 10022 /tmp/localfile user@localhost:/tmp/uploadedfile2
$ scp -P 10022 user@localhost:/tmp/uploadedfile2 /tmp/downloadedfile
~~~

（概念図）

大量のファイルを転送するならこの方がラク。



# Case1-2: 社外にあるPCから社内専用のサーバーにHTTP接続したい

（ネットワーク構成図）

社外から、社内にあるRedmineなどにアクセスする、というような場面。

手元のPC：

~~~
$ ssh user@203.0.113.1 -L 10080:192.168.0.110:80
~~~

手元のPCの別のコンソール：

~~~
$ curl -L "http://localhost:10080/"
~~~

（概念図）



# Case1-3: 社外にある他のPCからも社内専用のサーバーにHTTP接続したい

（ネットワーク構成図）

手元のPC：

~~~
$ ssh user@203.0.113.1 -L 10080:192.168.0.110:80 -g
~~~

同一セグメント内にある他のPC：

~~~
$ curl -L "http://192.168.1.10:10080/wp-admin/install.php"
~~~

（概念図）




# Case2: リモートフォワード（逆方向のポートフォワード）

（概念図）


# Case2-1: 社内のコンピューターから社外にあるPCにSSHでログインしたい

（ネットワーク構成図）

手元のPCの調子がおかしいので、社内にいる大野先輩に遠隔操作でトラブルシューティングしてもらう、というような場面。
手元のPCにはguestというユーザーを作成済みで、パスワード認証できるものとする。

手元のPC：

~~~
$ ssh user@203.0.113.1 -R 20022:localhost:22
~~~

社内にあるコンピューター（back）

~~~
user@back$ ssh user@192.168.0.100
user@front$ ssh -p 20022 guest@localhost
~~~

（概念図）

別解

~~~
user@back$ ssh user@192.168.0.100 -R 192.168.0.100:20022:localhost:22
~~~

社内にあるコンピューター（back）

~~~
user@back$ ssh -p 20022 guest@192.168.0.100
~~~

（概念図）


# Case2-2: インターネットに接続できる手元の携帯端末から、踏み台サーバーを経由して、手元のPCの上で動いているプレゼンツールを操作したい

（ネットワーク構成図）

http://rabbit-shocker.org/ja/rabbirack/

手元のPC：

~~~
$ ssh user@203.0.113.1 -R 203.0.113.1:20102:localhost:10102
~~~

手元の携帯端末

~~~
http://203.0.113.1:20102/
~~~

（概念図）

注意点：

 * 手元のPCをインターネットに公開しているのと全く同じなので、危険。
 * frontのsshdが、GatewayPorts yesまたはclientspecifiedに設定されている必要がある。
 * frontのiptablesで、指定のポートが解放されている必要がある。


# Case2-3: 外部から侵入不可能なネットワーク内にあるサーバーに、踏み台サーバーを経由して、手元のPCからSSH接続したい

frontに対して外部からのSSH接続を禁止して、「外には出て行けるが、中には入れない」ネットワークを用意する。

~~~
user@front$ su
root@front# ./disallow-ssh.sh
~~~

さらに、新たな踏み台サーバーとして、relay（203.0.113.2と仮定）を用意する。
これはsetup-relay.shでセットアップする。

（ネットワーク構成図）

frontからrelayへSSH接続して、リモートフォワードを設定する。

~~~
user@front$ ssh user@203.0.113.2 -R 20022:192.168.0.110:22
~~~

次に、手元のPCからrelayへSSH接続する。
そうしたら、20022番ポートでSSH接続する。

~~~
$ ssh user@203.0.113.2
user@front2$ ssh localhost -p 20022
~~~

（概念図）


# Case2-4: 外部から侵入不可能なネットワーク内にあるサーバーに、踏み台サーバーを経由して、手元のPCからHTTP接続したい

（ネットワーク構成図）

frontからrelayへSSH接続して、リモートフォワードを設定する。

~~~
user@front$ ssh user@203.0.113.2 -R 203.0.113.1:20080:192.168.0.110:80
~~~

手元のPC：

~~~
$ curl -L http://203.0.113.2:20080/
~~~

（概念図）

注意点：

 * サーバーをインターネットに公開しているのと全く同じなので、危険。
 * relayのsshdが、GatewayPorts yesまたはclientspecifiedに設定されている必要がある。
 * relayのiptablesで、指定のポートが解放されている必要がある。
 * front-relay間の接続が切れたらお手上げ。（自動再接続させたいならautosshを使う）




# Case3: ローカルフォワードとリモートフォワードの合わせ技

（概念図）

# Case3-1: 外部から侵入不可能なネットワーク内にあるサーバーに、踏み台サーバーを経由して、手元のPCからHTTP接続したい（より安全なやり方）

新たな踏み台サーバーとして、plain-relay（203.0.113.3と仮定）を用意する。
これはsetup-plain-relay.shでセットアップする。

 * plain-relayのsshdは、GatewayPorts noでもよい。
 * plain-relayのiptablesは、指定のポートが解放されていなくてもよい。
 * front-plain-relay間の接続が切れたらお手上げ。（自動再接続させたいならautosshを使う）

（ネットワーク構成図）

まず、frontからplain-relayへSSH接続して、リモートフォワードを設定する。

~~~
user@front$ ssh user@203.0.113.3 -R 20080:192.168.0.110:80
~~~

次に、手元のPCからplain-relayへSSH接続して、ローカルフォワードを設定する。

~~~
$ ssh user@203.0.113.3 -L 10080:localhost:20080
~~~

手元のPCの別のコンソール：

~~~
$ curl -L http://localhost:10080/
~~~

（概念図）

