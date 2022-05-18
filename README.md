# gfwlist2smartdns
列表内的域名使用含有'-group GFW -exclude-default-group'的server配置,参考smartdns.conf中
```
server-https https://dns.google/dns-query -check-edns -blacklist-ip -group GFW -exclude-default-group
```

缓存策略与速度检查策略请按需自行调整cache-size/speed-check-mode等参数

列表文件/etc/smartdns/gfw.conf可通过crontab定时更新
```
0 2 * * * curl -s https://raw.githubusercontent.com/RyoLee/gfwlist2smartdns/master/run.sh | bash -s -- -o /etc/smartdns/gfw.conf && /etc/init.d/smartdns reload
```
建议保存到本地运行,类似↓
```
0 2 * * * bash /opt/gfwlist2smartdns/run.sh -o /etc/smartdns/gfw.conf && /etc/init.d/smartdns reload
```
