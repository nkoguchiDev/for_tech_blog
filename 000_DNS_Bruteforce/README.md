```sh
cd src
sh environments-setup.sh
docker exec -it kali /bin/bash
apt-get update
apt install amass
amass -h
amass enum -active -d example.com -tr 172.20.0.10 -r 172.20.0.10
amass enum -brute -d example.com -tr 172.20.0.10 -r 172.20.0.10 --norecursive
apt-get -y install dnsrecon
dnsrecon -d example.com -n 172.20.0.10 -t brt
apt-get -y install seclists
apt-get -y install gobuster
gobuster dns --domain example.com --resolver 172.20.0.10 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
exit
```
