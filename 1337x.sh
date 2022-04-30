#!/bin/bash

# 1337x.wtf parser

sites["1337x.wtf"]="1337x"
1337x()
{
    local tmp_url="$(mktemp --tmpdir=${tmpdir})"
    local tmp_entry="$(mktemp --tmpdir=${tmpdir})"
    local descr date size seeds leechs unused url_link
    curl -s -o "${tmp_url}" "https://1337x.wtf/search/${query}/1/"
    local i=0
    while grep -E -m1 -A4 -e 'torrent\/[^"]*' > ${tmp_entry}; do
	sed -i 's_</i>[[:digit:]]*</span>__' "${tmp_entry}"
	IFS="$(printf '\x01')" read  -r descr seeds leechs date size unused unused \
	   <<<"$(grep -Eoe '>[^<]+<' ${tmp_entry} | tr -d '<>' | tr '\n' '\001')"
	url_link="$(grep -Eoe 'torrent\/[^"]*' ${tmp_entry})"
	magnet_link="$(curl -s "https://1337x.wtf/$url_link" | grep -m1 -o 'magnet:?[^"]*')"
	printf "%s\x01" "$descr" "$size" "$seeds" "$leechs" "$magnet_link" >> $entries
	echo >> $entries
	
	# Here for compliance with --max-sites option.
	((i++))
	((i==${max_sites})) && break
    done < ${tmp_url}
}
