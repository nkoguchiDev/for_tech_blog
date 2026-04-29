# DNSブルートフォース

## 前提条件

- `docker -v`コマンドでバージョン情報が出力される

## 演習方法

環境構築を行います。

```sh
cd src
sh environments-setup.sh
```

コンテナの中に入ります。

```sh
docker exec -it kali /bin/bash
```

コンテナに必要なパッケージをインストールします。

```sh
apt-get update
apt-get -y install seclists
apt-get -y install gobuster
```

ローカルのDNSに対してDNSブルートフォース攻撃を実行します。

```sh
gobuster dns --domain example.com --resolver 172.20.0.10 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

コンテナから出ます。

```sh
exit
```

環境をクリーンアップします。

```sh
sh environments-clean.sh
```
