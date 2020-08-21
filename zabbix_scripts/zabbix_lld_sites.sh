#!/bin/bash

###
# Script that read a list of hosts and create one JSON in Zabbix LLD format to be used to monitor some sites parameters
# If any problem happen, the data JSON return will be empty to avoid any problems with Zabbix server.
# license GPL v2.0

###
# the hosts file structure:
# theurl;theprotocol;
#
# Example:
# google.com;http;
# yahoo.com;https;
#
# - blank lines will be ignored
# - commented lines will be ignored
# - multiple sources are accepted

###
# functions
createTempFiles()
{
  tmp_file_domains_list=$(mktemp /tmp/zabbix_lld_monitor.XXXXXXX)
  tmp_file_zabbix_json=$(mktemp /tmp/zabbix_lld_monitor.XXXXXXXX)
}

getHostsFiles()
{
  aux_tmp_file_domains_list=$(mktemp /tmp/zabbix_lld_monitor.XXXXXXXX)
  for hostlist in $url_domains_list
  do
    wget --no-check-certificate --timeout=10 -O $aux_tmp_file_domains_list $url_domains_list &> /dev/null
    return_wget=$?
    
    if [ $return_wget -ne 0 ]
    then
      return 1
    else
      # remove blank and commented lines
      sed -i -e '/^\s*#.*$/d' -e '/^\s*$/d' $aux_tmp_file_domains_list
      # build the final domains list file
      cat $aux_tmp_file_domains_list >> $tmp_file_domains_list
    fi
  done
  # remove temp file
  rm -f $aux_tmp_file_domains_list
  return 0
}

# count how much lines the domains list file has
getHostsNumber()
{
  count_hosts_number=$(awk '!/^#/ && !/^$/{c++}END{print c}' "$tmp_file_domains_list")
}

createJsonHead()
{
  echo -e "{\"data\":[\c" > $tmp_file_zabbix_json
}

createJsonTail()
{
  echo -e "]}\c" >> $tmp_file_zabbix_json
}

createJsonBody()
{
  IFS=";"
  aux_count=0
  while read url protocol
  do
    echo -e "{\"{#URL}\":\"$url\",\"{#PROTOCOL}\":\"$protocol\"}\c" >> $tmp_file_zabbix_json
    aux_count=$((++aux_count))
    if [ $aux_count -lt $count_hosts_number ]
    then
      echo -e ",\c" >> $tmp_file_zabbix_json
    fi
  done < $tmp_file_domains_list
}

printJson()
{
  cat $tmp_file_zabbix_json
}

cleanTempFiles()
{
  rm -f $tmp_file_domains_list $tmp_file_zabbix_json
}

###
# global vars
#
# to be configured by the user:
# url_domains_list is to add all sources of hosts to be monitored. Can be more than one source, separated by space.
url_domains_list="http://host.example.com/hosts.txt"
#
# not needed to changed unless you know what you are doing
tmp_file_domains_list=""
tmp_file_zabbix_json=""
count_hosts_number=""
##

# start process the hosts
createTempFiles
getHostsFiles
getHostsNumber
createJsonHead
createJsonBody
createJsonTail
printJson
cleanTempFiles
