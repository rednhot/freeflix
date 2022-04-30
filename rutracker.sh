#!/bin/bash

# rutracker.org parser
# Note that in order to use it, you need an account, so first register.
# Mostly useful for russian-speaking users.

sites["rutracker.org"]="rutracker"
rutracker()
{
    local tmp_entry tmp_cookies tmp_url
    local descr size seeds leechs url_link magnet_link
    tmp_entry=$(mktemp --tmpdir=${tmpdir})
    tmp_cookies=$(mktemp --tmpdir=${tmpdir})
    tmp_url=$(mktemp --tmpdir=${tmpdir})
    username=$(printf '' | dmenu -l 0 -p 'Username: ')
    password=$(printf '' | dmenu -l 0 -p 'Password: ')
    curl -s -b ${tmp_cookies} -c ${tmp_cookies} -X POST \
	 -d "login_username=${username}" -d "login_password=${password}" -d 'login=вход' \
	 'https://rutracker.org/forum/login.php' >/dev/null 2>&1
    curl -s -b ${tmp_cookies} -c ${tmp_cookies} -o ${tmp_url}  "https://rutracker.org/forum/tracker.php?nm=${query}"
    local i=0
    while grep -A26 -m1 -Ee 'wbr t-title' > ${tmp_entry} ; do
	# line mapping
	# 2-descr 10-size 12-seeds 13-leechs
	grep "проверено" ${tmp_entry} >/dev/null || continue
	url_link=$(grep -m1 -o 'viewtopic\.php[^"]*' ${tmp_entry})
	descr=$(sed -n 2p < ${tmp_entry} | grep -Eoe '>[^<]+<' | tr -d '<>' | tr '\n' ' ')
	size=$(sed -n 10p ${tmp_entry} | grep -Eoe '>[[:digit:]][^<]*<' | sed -E 's/\&nbsp;/ /; s/(MB|GB|TB)(.*)/\1/' | tr -d '<>')
	seeds=$(sed -n 12p ${tmp_entry} | grep -Eoe '>[[:digit:]][^<]*<' | tr -d '<>')
	leechs=$(sed -n 13p ${tmp_entry} | grep -Eoe '>[[:digit:]][^<]*<' | tr -d '<>')
	magnet_link=$(curl -b ${tmp_cookies} -c ${tmp_cookies} -s "https://rutracker.org/forum/${url_link}" | grep -m1 -oe 'magnet:?[^"]*')
	printf "%s\x01" "$descr" "$size" "$seeds" "$leechs" "$magnet_link" >> ${entries}
	echo >> ${entries}

	# As freeflix interface dictates, we need that for --max-sites option
	((i++))
	((i==${max_sites})) && break 
    done <<<"$(iconv -c -f cp1251 -t utf-8//IGNORE ${tmp_url})" # Re-encoding from cp1251 to utf-8
}
