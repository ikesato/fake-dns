概要
====

DNS サーバーを fake する Docker 環境です。
デバッグなどで、一時的に DNS 設定を書き換えて、本来のホストではないサーバーを返し、http アクセスなどをキャプチャできます。
docker-compose で DNSサーバー(bind) と nginx を入れています。

例えば本来は

client -> real-server

のように http アクセスがあったとして

client -> fake-server -> real-servdr

のように間に、この fake-server を仕込ませることができます。


使い方
======

1. files/bind/named.conf.local を編集  
 ```
 zone "example.com" {
 ```
 の "example.com" を目的のサーバーのドメインに書き換えてください。  
 例  
 例えば www.hoge.com の場合は "hoge.com" がドメインになります。  
 "example.com" -> "www.hoge.com"  

2. files/bind/zones/example.com.db を編集  
 -  example.com を全て 1 で変更したドメインに置換します。
 - DNSレコードを編集します。  
  必要なのは NS レコードが参照している ns1 のAレコードと、目的のホスト名です。
  登録するIPアドレスは Docker を起動する端末のIPアドレスになります。
  例えば www.hoge.com を登録したい場合は以下のようになります。
  ```
  hoge.com. IN NS ns1.hoge.com.
  ns1   IN A 192.168.0.123
  www   IN A 192.168.0.123
  ```

3. files/bind/zones/rev.example.com.db を編集  
 -  example.com を全て 1 で変更したドメインに置換します。
 - 逆引き DNSレコードを編集します。  
  2で登録したIPの逆引き用のレコードです。  
  2の例の場合は以下のようになります。
  ```
             IN NS ns1.hoge.com.
  123        IN PTR ns1
  123        IN PTR www
  ```

4. files/nginx/conf.d/example.com.conf を編集
```
proxy_pass http://example.com;
```
の example.com を目的にホスト名に変更します。  
1,2,3の例ですと以下になります。  
```
proxy_pass http://www.hoge.com;
```


5. Docker のビルド
```
docker-compose build
```

6. Docker の実行
```
docker-compose up
```

7. Docker の終了
```
Ctrl-C または別ターミナルから
docker-compose stop
```
