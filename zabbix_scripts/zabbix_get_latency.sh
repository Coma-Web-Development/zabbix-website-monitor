#!/bin/bash

url=$1
ping_result=$(ping -W 4 -c 4 $1 2> /dev/null | tail -1| awk '{print $4}' | cut -d '/' -f 2)

if echo $ping_result | egrep -iq "^[0-9]+\.[0-9]+$"
then
  echo $ping_result
else
  echo -1
fi
