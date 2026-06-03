# Virtual Host ブルートフォース

## 注意

GoBusterを利用する前に、対象システムの所有者または管理者から必ず許可を取得してください。
許可なく実行すると、法令に抵触するおそれがあります。

## 概要

この演習では、`gobuster dns` でサブドメインを列挙し、続けて `gobuster vhost` で同一 IP 上の Virtual Host を探索する手順を学びます。  
ローカルで構築した DNS サーバーと Nginx プロキシに対して問い合わせを行い、サブドメイン探索と Virtual Host 列挙の基本的な流れと検証方法を確認します。

## 前提条件

- `docker -v`コマンドでバージョン情報が出力される

## 構成

- **攻撃側サーバー（Kaliコンテナ）**
  - `gobuster dns` を実行し、`example.com` のサブドメインを総当たりで問い合わせます。
  - 問い合わせ先（リゾルバ）は `172.30.1.10` を指定します。

- **DNSサーバー（BINDコンテナ）**
  - `example.com` のゾーン情報を保持し、Kali からの DNS クエリに応答します。
  - サブドメインの有無に応じて応答内容が変わるため、列挙結果の確認対象となります。

- **プロキシサーバー（Nginxコンテナ）**
  - IP アドレス `172.30.1.100` で HTTP（80番）を待ち受け、同一 IP 上で複数の Virtual Host を `server_name` により振り分けます。
  - クライアントが送る `Host` ヘッダーの値によって応答（ステータスコード・本文）が変わるため、`gobuster vhost` の列挙対象となります。

- **ネットワーク**
  - 3つのコンテナは Docker ネットワーク上で接続されます。
  - DNS 列挙の流れ: `Kali` → `BIND`（`172.30.1.10`）で DNS クエリ/レスポンスを検証します。
  - Virtual Host 列挙の流れ: `Kali` → `Nginx`（`172.30.1.100`）へ `Host` ヘッダーを変えながら HTTP リクエストを送り、応答の差分で存在するホスト名を判別します。

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
見つかったサブドメインを見ると、同じIPアドレスに名前解決されることがわかります。
これにより、同一ホストでさまざまなドメインを受けているだろうと推測できます。

resolverを指定しない場合、インターネットで実際に運用されているドメインに対してDNSブルートフォース攻撃を行うため、必ず`--resolver`オプションによりローカルで稼働しているリゾルバを指定してください。

```sh
gobuster dns --domain example.com --resolver 172.30.1.10 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

ローカルのプロキシサーバーに対してVirtual Hostブルートフォース攻撃を実行します。
この時、DNSブルートフォースでは発見できなかったドメインで受けていることがわかります。
これにより、非公開状態として運用されているシステムを発見することができました。

```sh
gobuster vhost --domain example.com -u http://172.30.1.100 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt --append-domain true
```

コンテナから出ます。

```sh
exit
```

環境をクリーンアップします。

```sh
sh environments-clean.sh
```
