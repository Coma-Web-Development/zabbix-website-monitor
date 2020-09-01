# zabbix-website-monitor
Zabbix LLD and scripts rules to monitor websites. The goal is to get something more complete than Zabbix web scenarios.

# Sponsor: [coma.lv](https://coma.lv)

![coma.lv](https://coma.lv/coma-logo.png)

We are a WordPress development company from Latvia focusing on full-stack WordPress development and administration. 

We offer our clients design, development, hosting and support of WordPress projects created in our agency.

In this git we are going to share useful snippets for technologies that we are using in our everyday tasks.

# Features and the status

Feature | Status
------- | ------ 
Zabbix template | to do
Connect time (3-way handshake) | ready
Latency | ready
HTTP response code | ready
Lookup time | ready
Lighthouse benchmark | to do


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

**Note:** yarn, lighthouse, nodejs and related packages are only needed if you want create reports about performance.

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

# Documentation

## How to install

1. Import the template file to your zabbix server (check the zabbix_template dir)

```bash
zabbix_website_monitor_.xml
```

2. Copy the zabbix scripts to your zabbix scripts dir (check the zabbix_scripts dir) in the server that will monitor your sites.

By default, it come configured to be installed on /opt/zabbix/. Do not forget to provide executable permission to the owner and fix the owner/group to zabbix:zabbix.

3. Copy the zabbix conf file (check the zabbix_conf dir) to the conf dir of zabbix agent that will monitor the sites. Usually the dir is:
```bash
/etc/zabbix/zabbix_agentd.d/
``` 

**Notes:**
- Check the correct zabbix agent dir conf location.
- You need to restart the zabbix-agent to load the conf file
- If you will use other directory different of /opt/zabbix/ to install the scripts, you need to change the absolute path of he scripts in the file

```bash
zabbix_website_monitor.conf
```

To restart the the Zabbix agent:

```bash
systemctl restart zabbix-agent
```

## How to update

1. To update the scripts, you only have to copy the content of the below dir to your zabbix script directory.

```bash
zabbix_scripts
``` 

2. To update the zabbix agent conf file, you need to override the new version in the zabbix agent conf directoy.

**Important:** You need to change the scripts directory if you use a custom directory (different from /opt/zabbix). After copy the new files, you need restart the zabbix-agent.

3. Import again the template and override the old one.

**Important:** If you customized anything, we recommend export your template and manually edit the XML file to add the new features. If you know how to use git patch, will be easier than do manual edit.

## How to remove

1. Delete the template from your zabbix dashboard.
2. Delete the scripts that you copied from the git.
3. Remove the zabbix-agent conf file and restart zabbix-agent.

## Items monitored explained

TO DO
