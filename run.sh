#!/usr/bin/env bash
while getopts 'o:' OPT; do
  case $OPT in
    o) O_PATH="$OPTARG"&&MODE="file";;
    *) echo "Unknown error while processing options";;
  esac
done
curl -sS https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt | \
  base64 -d | sort -u | sed '/^$\|@@/d'| sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' | \
  sed '/apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /qq\.com/d' | \
  sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' | grep '^[0-9a-zA-Z\.-]\+$' | \
  grep '\.' | sed 's#^\.\+##' | sort -u > /tmp/temp_gfwlist1

curl -sS https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf | \
  sed 's/ipset=\/\.//g; s/\/gfwlist//g; /^server/d' > /tmp/temp_gfwlist2

curl -sS https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt > /tmp/temp_gfwlist3

cat /tmp/temp_gfwlist1 /tmp/temp_gfwlist2 /tmp/temp_gfwlist3 | sort -u | sed 's/^\.*//g' > /tmp/temp_gfwlist
cat /tmp/temp_gfwlist | sed 's/^/\./g' > /tmp/gfw.conf
sed -i 's/^/nameserver \//' /tmp/gfw.conf
sed -i 's/$/\/GFW/' /tmp/gfw.conf
if [ -z $O_PATH ];then
  cat /tmp/gfw.conf 
else
  cat /tmp/gfw.conf > ${O_PATH}
fi
rm -f /tmp/temp_gfwlist1 /tmp/temp_gfwlist2 /tmp/temp_gfwlist3 /tmp/temp_gfwlist /tmp/gfw.conf
