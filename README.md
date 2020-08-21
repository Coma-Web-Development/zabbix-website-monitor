# zabbix-website-monitor
Zabbix LLD and scripts rules to monitor websites. The goal is to get something more complete than Zabbix web scenarios.

# Linux requirements
- Unix or Linux environment
- Packages: curl, wget, awk, bash, nodejs, yarn, chromium

Centos 7.x commands:
```bash
yum -y install epel-release
yum -y install curl wget chromium
curl –sL https://rpm.nodesource.com/setup_12.x | sudo bash -
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum -y install nodejs gcc-c++ make yarn
yarn global add lighthouse
```
