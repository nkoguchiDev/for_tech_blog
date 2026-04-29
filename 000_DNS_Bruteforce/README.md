```sh
cd src
sh environments-setup.sh
docker exec -it kali /bin/bash
apt-get update
apt-get -y install seclists
apt-get -y install gobuster
gobuster dns --domain example.com --resolver 172.20.0.10 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
exit
```
