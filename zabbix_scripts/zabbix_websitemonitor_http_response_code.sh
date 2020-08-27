#!/bin/bash

# script to get the url http return code to try to get errors
# - redirects will be ignored
# - certificates will be ignored
# - curl errors will be 
 
url="$2://$1"

curl_result=$(curl -k --max-time 5 -sL -D - $url -o /dev/null | egrep "HTTP" | tail -n 1)
curl_return=$?

curl_result=$(echo $curl_result | cut -d" " -f2)

if [[ "${curl_result}x" == "x" ]]
then
  # curl could not take valid result
  echo 0
fi

# return the curl result
echo $curl_result
