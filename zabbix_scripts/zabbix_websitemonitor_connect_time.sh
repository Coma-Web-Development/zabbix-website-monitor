#!/bin/bash

url=$1
protocol=$2
curl_result=$(curl -s -w  %{time_connect} -o /dev/null ${protocol}://${url})
curl_return=$?

bc_calc=$(echo "curl_return > 0" | bc -l)

if [ $bc_calc -eq 0 ]
then
  echo $curl_result
else
  echo -1
fi
