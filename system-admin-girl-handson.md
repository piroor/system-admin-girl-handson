# シス管系女子 Hands-on

subtitle
:   試して覚えよう！
    SSHポートフォワーディング

author
:   Piro / 結城洋志

institution
:   株式会社クリアコード

allotted_time
:   60m



# SSHポートフォワードって何？

 * SSHの通信経路を使った
   パケット転送
 * 別々のネットワーク同士を
   繋げられる
 * 「トンネリング」などとも
   呼ばれる


# こんな事、ありませんか？

![](images/situation1.png){:relative_width='80'}

{::comment}
 * 社内ネットワーク内からしかアクセスできない社内サイトがある。
 * 自分は今、社外にいるが、社内サイトにアクセスしたい。
   * 大事な資料がそこにしかないが、ダウンロードしておくのを忘れていた。
   * 寝坊してしまったが、こっそり「出勤」ボタンをクリックしたい。
{:/comment}

# こんな事、ありませんか？

![](images/situation2.png){:relative_width='80'}

{::comment}
 * 自分は今、社外にいるが、手元のPCでトラブルが発生している。
 * 社内にいる頼れる先輩に連絡して、リモート操作でトラブルを解決してもらいたい。
{:/comment}




# 使用するサーバーの準備

 * 踏み台になる*中継サーバー*
 * 最終的な接続先になる
   *社内専用Webサーバー*

# 目指すゴール

![](images/01-setup-network.png){:relative_width='80'}


# ネットワークの作成 (1/5)

![](images/screenshots/add-localnetwork-step1.png){:relative_width='80'}

# ネットワークの作成 (2/5)

![](images/screenshots/add-localnetwork-step2.png){:relative_width='80'}

# ネットワークの作成 (3/5)

![](images/screenshots/add-localnetwork-step3.png){:relative_width='80'}

# ネットワークの作成 (4/5)

![](images/screenshots/add-localnetwork-step4.png){:relative_width='80'}

# ネットワークの作成 (5/5)

![](images/screenshots/add-localnetwork-step5.png){:relative_width='80'}



# 踏み台にする中継サーバー

![「front」と呼ぶことにします](images/01-setup-network-front.png){:relative_width='80'}

# frontの作成 (1/5)

![](images/screenshots/add-vps-step1.png){:relative_width='80'}

# frontの作成 (2/5)

![](images/screenshots/add-vps-step2.png){:relative_width='80'}

# frontの作成 (3/5)

![](images/screenshots/add-vps-step3-front.png){:relative_width='50' align="right" relative_margin_right=-20}

 * 既定の
   テンプレート
   イメージで
   作成
 * [メモ用シート](printable-sheets/memo.html)
   にrootの
   パスワードを
   メモ

# frontの作成 (4/5)

![](images/screenshots/add-vps-step4.png){:relative_width='80'}

# frontの作成 (5/5)

![](images/screenshots/add-vps-step5.png){:relative_width='80'}

# frontの名前の設定

![](images/screenshots/add-vps-step14-rename.png){:relative_width='80'}

分かりやすいように
「front」とラベルを付ける

# frontのIPアドレスの確認

![](images/screenshots/add-vps-step15-ipaddress.png){:relative_height='70'}

[メモ用シート](printable-sheets/memo.html)に
IPアドレスを書き込んでおく


# frontのシャットダウン (1/3)

![](images/screenshots/add-vps-step6-shutdown.png){:relative_width='80'}

# frontのシャットダウン (2/3)

![](images/screenshots/add-vps-step7-shutdown.png){:relative_width='80'}

# frontのシャットダウン (3/3)

![](images/screenshots/add-vps-step8-shutdown.png){:relative_width='80'}

# frontのネットワーク設定 (1/5)

![](images/screenshots/add-vps-step9-setup.png){:relative_width='80'}

# frontのネットワーク設定 (2/5)

![](images/screenshots/add-vps-step10-setup.png){:relative_width='80'}

# frontのネットワーク設定 (3/5)

![](images/screenshots/add-vps-step11-setup.png){:relative_width='80'}

# frontのネットワーク設定 (4/5)

![](images/screenshots/add-vps-step12-setup.png){:relative_width='80'}

# frontのネットワーク設定 (5/5)

![](images/screenshots/add-vps-step13-setup.png){:relative_width='80'}


# frontの再起動 (1/4)

![](images/screenshots/setup-vps-step1.png){:relative_width='80'}

# frontの再起動 (2/4)

![](images/screenshots/setup-vps-step2.png){:relative_width='80'}

# frontの再起動 (3/4)

![](images/screenshots/setup-vps-step3.png){:relative_width='80'}

# frontの再起動 (4/4)

![](images/screenshots/setup-vps-step4.png){:relative_width='80'}

# frontの初期化 (1/6)

![](images/screenshots/setup-vps-step5.png){:relative_height='90'}

# frontの初期化 (2/6)

![](images/screenshots/setup-vps-step6.png){:relative_width='80'}

# frontの初期化 (3/6)

![](images/screenshots/setup-vps-step7.png){:relative_height='70'}

~~~
root@front# curl https://raw.githubusercontent.com/piroor/
              system-admin-girl-handson/master/scripts/setup-front.sh | bash
~~~

{::comment}
コピペ用：
curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/scripts/setup-front.sh | bash
{:/comment}

# frontの初期化 (4/6)

![](images/screenshots/setup-vps-step8.png){:relative_width='80'}

# frontの初期化 (5/6)

![](images/screenshots/setup-vps-step9.png){:relative_width='80'}

# frontの初期化 (6/6)

初期化が完了したら、
userユーザのパスワードを
変更しておく。

~~~
root@front# su user
user@front$ passwd
~~~

[メモ用シート](printable-sheets/memo.html)に
userのパスワードを書き込んでおく。


# 社内専用Webサーバー

![「back」と呼ぶことにします](images/01-setup-network-back.png){:relative_width='80'}

# backの作成 (1/2)

![](images/screenshots/add-vps-step1.png){:relative_width='80'}

# backの作成 (2/2)

![](images/screenshots/add-vps-step3-back.png){:relative_width='50' align="right" relative_margin_right=-20}

 * nginx,
   WordPress
   入りの
   テンプレート
   イメージ
 * [メモ用シート](printable-sheets/memo.html)
   にrootの
   パスワードを
   メモ

# backの名前の設定

![](images/screenshots/add-vps-step14-rename.png){:relative_width='80'}

分かりやすいように
「back」とラベルを付ける。

# backのIPアドレスの確認

![](images/screenshots/add-vps-step15-ipaddress.png){:relative_width='80'}

[メモ用シート](printable-sheets/memo.html)にIPアドレスを
書き込んでおく。


# backのネットワーク設定

frontと同じ手順で
プライベートネットワークに
参加させる。

 1. シャットダウン
 2. ネットワーク
    インターフェースを追加
 3. 起動


# backの初期化 (1/2)

 * frontと同じ手順で、
   スクリプトを使って初期化する。
 * スクリプトのダウンロードURLが
   front用とは異なるので注意する。

~~~
root@back# curl https://raw.githubusercontent.com/piroor/
             system-admin-girl-handson/master/scripts/setup-back.sh | bash
~~~

{::comment}
コピペ用：
curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/scripts/setup-back.sh | bash
{:/comment}

# backの初期化 (2/2)

初期化が完了したら、
userユーザのパスワードを
変更しておく。

~~~
root@back# su user
user@back$ passwd
~~~

[メモ用シート](printable-sheets/memo.html)に
userのパスワードを書き込んでおく。



# WordPress動作確認 (1/3)

backのIPアドレスを指定して
ブラウザで開いてみる。

# WordPress動作確認 (1/3)

![](images/screenshots/setup-wp-step1.png){:relative_height='90'}

# WordPress動作確認 (1/3)

 初期設定の画面が出るので
適当に設定する。

# WordPress動作確認 (2/3)

![](images/screenshots/setup-wp-step2.png){:relative_width='80'}

# WordPress動作確認 (3/3)

![](images/screenshots/setup-wp-step3.png){:relative_width='80'}

もう1度、backのIPアドレスを指定してブラウザで開いてみる。
セットアップが完了したWordPressの画面が出る。

例： http://back/




# backを隔離する

backにログインし、root権限で
rootのホームにある
設定変更用スクリプトを実行する。

~~~
# ~/deactivate-eth0.sh
~~~

# 準備完了

![](images/01-setup-network.png){:relative_width='80'}




# ここから本編

SSHポートフォワーディングを
試してみよう！

# ポートフォワーディングとは？

![](images/02-port-forwarding.png){:relative_width='80'}



# Case0:

ポートフォワードが
必要ないケース

# Case0-1: 

![社外からログイン](images/case0-1.png){:relative_width='80'}

# step1:

![中継サーバーにログイン](images/case0-1-1.png){:relative_width='80'}

# step1:

~~~
$ ssh user@front
~~~

# step2: 

![社内サーバーにログイン](images/case0-1-2.png){:relative_width='80'}

# step2:

~~~
user@front$ ssh user@192.168.0.110
~~~



# Case0-2: 

![社外からファイルをアップロード](images/case0-2.png){:relative_width='80'}

# step1:

![中継サーバーにコピー](images/case0-2-1.png){:relative_width='80'}

# step1:

~~~
$ echo "Hello!" >  /tmp/localfile
$ scp /tmp/localfile user@front:/tmp/uploadedfile
~~~

# step2: 

![中継サーバーにログイン](images/case0-2-2.png){:relative_width='80'}

# step2:

~~~
$ ssh user@front
~~~

# step3:

![中継サーバーから
社内サーバーにコピー](images/case0-2-3.png){:relative_width='80'}

# step3:

~~~
user@front$ scp /tmp/uploadedfile
              user@192.168.0.110:/tmp/uploadedfile
~~~

{::comment}
コピペ用
scp /tmp/uploadedfile user@192.168.0.110:/tmp/uploadedfile
{:/comment}

# Case1

*ローカルフォワード*
（順方向のポートフォワード）

# ローカル→リモートの転送

![](images/02-port-forwarding.png){:relative_width='80'}


# Case1-1: 

![社外からファイルを直接アップロード](images/case0-2.png){:relative_width='80'}

# step1: 

![ローカルフォワードを有効化](images/case1-1-1.png){:relative_width='80'}

# step1: 

~~~
$ ssh user@front -L 10022:192.168.0.110:22
~~~

*L*ocal→Remote の
*L*ocal Forward だから *L*

# step1:

![](images/case1-1-1-forwarded.png){:relative_width='80'}

# step2: 

![ファイルをコピー](images/case1-1-2.png){:relative_width='80'}

# step2: 

~~~
$ scp -P 10022 /tmp/localfile user@localhost:/tmp/uploadedfile2
$ scp -P 10022 user@localhost:/tmp/uploadedfile2 /tmp/downloadedfile
~~~

双方向にコピーできる。




# Case1-2: 

![社外から社内Webサイトを見る](images/case1-2.png){:relative_width='80'}

# step1: 

![ローカルフォワードを有効化](images/case1-2-1.png){:relative_width='80'}

# step1: 

~~~
$ ssh user@front -L 10080:192.168.0.110:80
~~~

*L*ocal→Remote の
*L*ocal Forward だから *L*

# step2: 

![HTTPリクエストを送る](images/case1-2-2.png){:relative_width='80'}

# step2: 

~~~
$ firefox http://localhost:10080/
~~~

~~~
$ w3m http://localhost:10080/
~~~

~~~
$ curl http://localhost:10080/
~~~





# Case2:

*リモートフォワード*
（逆方向のポートフォワード）

# リモート→ローカルの転送

![](images/03-remote-forward.png){:relative_width='80'}


# Case2-1: 

![社内から社外のPCにログイン](images/case2-1.png){:relative_width='80'}

# Case2-1: 

 * 手元のPCにはguestという
   ユーザーを作成済みで、
   パスワード認証できるものとする。

# step1: 

![リモートフォワードを有効化](images/case2-1-1.png){:relative_width='80'}

# step1: 

~~~
$ ssh user@front -R 20022:localhost:22
~~~

*R*emote→Local の
*R*emote Forward だから *R*

# step1: 

![](images/case2-1-1-forwarded.png){:relative_width='80'}

# step2: 

![中継サーバーにログイン](images/case2-1-2.png){:relative_width='80'}

# step2: 

~~~
user@back$ ssh user@192.168.0.100
~~~

# step3: 

![社外PCにログイン](images/case2-1-3.png){:relative_width='80'}

# step3: 

~~~
user@front$ ssh -p 20022 guest@localhost
~~~







# Case2-2: 

![侵入不可能なネットワーク内の
サーバーに社外からログイン](images/case2-2.png){:relative_width='80'}

# 準備1: 

![frontに社外からログインできなくする](images/case2-2.png){:relative_width='80'}

# 準備1: 

~~~
root@front# ~/disallow-ssh.sh
~~~

# 確かめてみよう

![](images/case2-2-closed.png){:relative_width='80'}

# 確かめてみよう

手元のPCからfrontへ

~~~
$ ssh user@back
~~~

backからfrontへ

~~~
user@back$ ssh user@192.168.0.100
~~~

# 準備2: 

![新たな中継サーバーを作成](images/case2-2-relay.png){:relative_width='80'}

# 準備2: 

 * 新たな中継サーバー用の
   VPSを作成する
 * コンソールからログインして
   初期設定を行う

~~~
root@relay# curl https://raw.githubusercontent.com/piroor/
              system-admin-girl-handson/master/scripts/setup-relay.sh | bash
root@relay# su user
user@relay$ passwd
~~~

{::comment}
コピペ用
curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/scripts/setup-relay.sh | bash
{:/comment}

[メモ用シート](printable-sheets/memo.html)に
各種情報を書き込んでおく。


# step1: 

![リモートフォワードの有効化](images/case2-2-1.png){:relative_width='80'}

# step1: 

~~~
user@front$ ssh user@relay -R 20022:192.168.0.110:22
~~~

*R*emote→Local の
*R*emote Forward だから *R*

# step1: 

![リモートフォワードの有効化](images/case2-2-1-forwarded.png){:relative_width='80'}

# step2: 

![relayへログイン](images/case2-2-2.png){:relative_width='80'}

# step2: 

~~~
$ ssh user@relay
~~~

# step3: 

![社内サーバーへログイン](images/case2-2-3.png){:relative_width='80'}

# step3: 

~~~
user@relay$ ssh -p 20022 user@localhost
~~~






# Case3: 

ローカルフォワードと
リモートフォワードの
*合わせ技*


# Case3:

![侵入不可能なネットワーク内の
社内Webサイトを、社外から見る](images/case3.png){:relative_width='80'}

# step1: 

![リモートフォワードの有効化](images/case3-1.png){:relative_width='80'}

# step1: 

~~~
user@front$ ssh user@relay -R 20080:192.168.0.110:80
~~~

*R*emote→Local の
*R*emote Forward だから *R*

# step2: 

![ローカルフォワードの有効化](images/case3-2.png){:relative_width='80'}

# step2: 

~~~
$ ssh user@relay -L 10080:localhost:20080
~~~

*L*ocal→Remote の
*L*ocal Forward だから *L*

# step3: 

![HTTPリクエストを送る](images/case3-3.png){:relative_width='80'}

# step3: 

~~~
$ firefox http://localhost:10080/
~~~

~~~
$ w3m http://localhost:10080/
~~~

~~~
$ curl http://localhost:10080/
~~~

# まとめ：ローカルフォワード

![](images/matome-local.png){:relative_width='80'}

# まとめ：リモートフォワード

![](images/matome-remote.png){:relative_width='80'}

# まとめ：両者の連携

![](images/matome-both.png){:relative_width='80'}


