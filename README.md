# zabbix-website-monitor
Zabbix LLD and scripts rules to monitor websites. The goal is to get something more complete than Zabbix web scenarios.

# Features and the status

Feature | Status
------- | ------ 
Zabbix template | ready
Connect time (3-way handshake) | ready
Latency | ready
HTTP response code | ready
Lookup time | ready
Lighthouse benchmark | to do


# Linux requirements
- Unix or Linux environment
- Hosts list file to be monitored
- Opensource packages: curl, wget, awk, bash, nodejs, yarn, chromium, bc, ping, jq
- zabbix-agent configured with timeout of 30 seconds

Centos 7.x commands:
```bash
# to monitoring work
yum -y install jq curl bc

# to benchmark monitoring work
yum -y install epel-release
yum -y install chromium
curl –sL https://rpm.nodesource.com/setup_12.x | sudo bash -
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum -y install nodejs gcc-c++ make yarn
yarn global add lighthouse
```

**Note:** yarn, lighthouse, chromium, nodejs and related packages are only needed if you want create reports about performance.

# Hosts list file

You have to create on dir and include in this dir one or more files with a list of hosts to be monitored. Every file must list one host per line and you must follow the standard below.

**The "URL hosts list" standard:**
```bash
url;protocol;
# or
url:8080;protocol;
```

All empty or commented lines started with "#" will be ignored. Eventually invalid lines will be filtered to be ignored to avoid problems.

A real example of host conf file:
```bash
# https://example.com/hosts.txt file example
google.com;https;
bing.com;http;
example:8090;https;
example2:3000;http;
```

**Important:**
- All parameters must be separated by semicolon (;) symbol
- First parameter is the address with or without the port
- Second parameter is the protocol that will be used
- Last semicolon (;) symbol is needed and if the line does not has, the host will be ignored


**How it will work?**

The Zabbix LLD script, that will discover all the URLs to be monitored, will read all the files inside that directory to get all hosts that will be monitored. Every file will containe one host per line.

# Documentation

## How to install

1. Import the template file to your zabbix server (check the zabbix_template dir)

```bash
zabbix_website_monitor_.xml
```

2. Copy the zabbix scripts to your zabbix scripts dir (check the zabbix_scripts dir) in the server that will monitor your sites.

By default, it come configured to be installed on /opt/zabbix/. Do not forget to provide executable permission to the owner and fix the owner/group to zabbix:zabbix.

**Important**: Configure the 

```bash
url_list_directory=
```

variable with the absolute path that contain all **"URL hosts list files"**. The default path is 

```bash
/opt/zabbix/url_list_directory/
```

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

4. Change the zabbix-agent timeout to 30 seconds (maximum) and restart zabbix-agent.

```bash
# edit the zabbix-agent file, usually is the /etc/zabbix/zabbix_agentd.conf
# add or update the config:
Timeout=30
```

To restart the the Zabbix agent:

```bash
systemctl restart zabbix-agent
```

## How to update

1. Backup your template, your zabbix scripts dir and the zabbix conf file.

2. To update the scripts, you only have to copy the content of the below dir to your zabbix script directory.

```bash
zabbix_scripts
``` 
**Important:** If the Hosts lists directory is in different path from default (/opt/zabbix/url_list_directory/), you have to update the file with you custom directory.

3. To update the zabbix agent conf file, you need to override the new version in the zabbix agent conf directoy.

**Important:** You need to change the scripts directory if you use a custom directory (different from /opt/zabbix). After copy the new files, you need restart the zabbix-agent.

4. Import again the template and override the old one.

**Important:** If you customized anything, we recommend export your template and manually edit the XML file to add the new features. If you know how to use git patch, will be easier than do manual edit.

## How to remove

1. Delete the template from your zabbix dashboard.
2. Delete the scripts that you copied from the git.
3. Remove the zabbix-agent conf file and restart zabbix-agent.

## Items monitored explained

TO DO


# FAQ
1. **How to get all active domains from cPanel?** You can execute:
```bash
for line in `cat /etc/userdomains | sed s/[[:space:]]*//g | grep -v "^\*"`; do DOMAIN=`echo ${line} | cut -d ":" -f 1`; USERNAME=`echo ${line} | cut -d ":" -f 2`; if [ ! -f "/var/cpanel/suspended/${USERNAME}" ]; then echo ${DOMAIN}; fi; done
```
2. **How to get all domains from VestaCP?** You can execute:
```bash
v-list-users | tail -n +3 | awk '{print "v-list-web-domains "$1" | tail -n +3"}' | bash | awk '{ print $1}' | egrep -iv localhost
```
3. **How to get all active domains from Cyberpanel?** You can execute (you need jq package installed):
```bash
cyberpanel listWebsitesJson | jq -r 'fromjson[] | select(.state=="Active") | .domain'
```
