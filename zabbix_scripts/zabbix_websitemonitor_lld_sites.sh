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

# download the URLs list files and create one big list to be monitored
getHosts()
{
  aux_tmp_file_domains_list=$(mktemp /tmp/zabbix_lld_monitor.XXXXXXXX)
  aux_url_files=$(ls ${url_list_directory}/*)

  for hosts_list in $aux_url_files
  do
    if [ -f $hosts_list ]
    then
      cat $hosts_list >> $aux_tmp_file_domains_list
    fi
  done

  # remove empty and commented lines started with #
  sed -i -e '/^\s*#.*$/d' -e '/^\s*$/d' $aux_tmp_file_domains_list

  # build the final domains list file
  cat $aux_tmp_file_domains_list >> $tmp_file_domains_list

  # remove temp file
  rm -f $aux_tmp_file_domains_list
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
# the directory that contain all lists of hosts to be monitored. all files will be read.
url_list_directory="/opt/zabbix/url_list_directory/"

# not needed to be changed unless you know what you are doing
tmp_file_domains_list=""
tmp_file_zabbix_json=""
count_hosts_number=""
url_domains_list=""
##

# start process the hosts
createTempFiles
getHosts
getHostsNumber
createJsonHead
createJsonBody
createJsonTail
printJson
cleanTempFiles
