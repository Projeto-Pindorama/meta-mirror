#!/bin/sh
# Simple Shell Script to generate the SERVERINFO.txt that is displayed when otto(8) connects to the server and sync the metapackage
# It shall be on the website root (ex: example.com/SERVERINFO.txt), unless you create a subdomain that still having the directory
# organization/hierarchy that an Otto mirror would usually have (ex: otto.example.com/SERVERINFO.txt).i
# You can personalize it (both the message and script) without any trouble.
# License: Volkerdings-Slackware (or Public Domain).

ipaddr="`curl -s http://ipinfo.io/ip`"
http_server="`curl -sD- -o/dev/null ${ipaddr} | sed -n '/Server/p' | awk '{$1=""; print $0}'`"
total_memory="$[`sed 1q /proc/meminfo | awk '{print $2}'` / 1000]"
cpu_name="`cat /proc/cpuinfo | grep 'model name' | cut -f 2 -d ":" | awk '{$1=$1}1'`"
cpu_cores="`echo ${cpu_name} | wc -l `"
country_name="`curl -s https://ipapi.co/${ipaddr}/country_name`"
city_name="`curl -s https://ipapi.co/${ipaddr}/city/`"
latlong="`curl -s https://ipapi.co/${ipaddr}/latlong/`"

cat > SERVERINFO.txt <<-EOD
Server IP Address:  ${ipaddr}
Server hardware:    ${cpu_cores}x `printf '%s' "${cpu_name}" | uniq` with ${total_memory}MB
Server httpd(8):    ${http_server}
Server hostname:    `uname -n`
Server geolocation: ${city_name}, ${country_name}; ${latlong}
Webmaster contact:  ${EMAIL}
EOD
