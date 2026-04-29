# DNSブルートフォース

## 概要

この演習では、`gobuster dns` を使って対象ドメイン (`example.com`) のサブドメインを総当たりで列挙する手順を学びます。  
ローカルで構築した DNS サーバーに対して問い合わせを行い、サブドメイン探索の基本的な流れと検証方法を確認します。

## 前提条件

- `docker -v`コマンドでバージョン情報が出力される

## 構成

- **攻撃側サーバー（Kaliコンテナ）**
  - `gobuster dns` を実行し、`example.com` のサブドメインを総当たりで問い合わせます。
  - 問い合わせ先（リゾルバ）は `172.20.0.10` を指定します。

- **DNSサーバー（BINDコンテナ）**
  - `example.com` のゾーン情報を保持し、Kali からの DNS クエリに応答します。
  - サブドメインの有無に応じて応答内容が変わるため、列挙結果の確認対象となります。

- **ネットワーク**
  - 2つのコンテナは Docker ネットワーク上で接続されます。
  - 通信の流れは「Kali -> BIND(DNS)」の一方向で、DNS クエリ/レスポンスを通じて検証します。

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
