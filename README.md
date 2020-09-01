# zabbix-website-monitor
Zabbix LLD and scripts rules to monitor websites. The goal is to get something more complete than Zabbix web scenarios.

# Sponsor: https://coma.lv

![coma.lv](https://coma.lv/coma-logo.png)

We are a WordPress development company from Latvia focusing on full-stack WordPress development and administration. 

We offer our clients design, development, hosting and support of WordPress projects created in our agency.

In this git we are going to share useful snippets for technologies that we are using in our everyday tasks.

# Linux requirements
- Unix or Linux environment
- Packages: curl, wget, awk, bash, nodejs, yarn, chromium, bc

Centos 7.x commands:
```bash
yum -y install epel-release
yum -y install curl wget chromium
curl –sL https://rpm.nodesource.com/setup_12.x | sudo bash -
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum -y install nodejs gcc-c++ make yarn bc
yarn global add lighthouse
```

# Hosts list
You need to create a hosts list to be monitored and make it available through some http server, because the script use curl to make some testes.
The hosts list standard:
```bash
url;protocol;
# or
url:8080;protocol;
```

All empty or commented lines started with "#" will be ignored. Eventually invalid lines will be filtered to be ignored to avoid problems.

A real example of host conf file:
```bash
google.com;https;
bing.com;http;
example:8090;https;
example2:3000;http;
```

The script that read the hosts lists files is the

```bash
zabbix_websitemonitor_lld_sites.sh
```

file. It will read the hosts files and generate a JSON in Zabbix LLD standard. The parameters will be the URL's (one or more) of hosts that you want to monitor.

Real example:
```bash
zabbix_websitemonitor_lld_sites.sh https://example.com/hosts.txt http://example2:8080/hosts.txt https://example.example3.net/domains.txt
```

#
