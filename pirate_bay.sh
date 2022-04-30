#!/bin/bash

# piratebay.party parser

sites["piratebay.party"]="pirate_bay"
pirate_bay()
{
    local tmp_url="$(mktemp --tmpdir=${tmpdir})"
    local tmp_entry="$(mktemp --tmpdir=${tmpdir})"
    local tmp_parse="$(mktemp --tmpdir=${tmpdir})"
    local descr date size seeds leechs link
    
    curl -s -o "${tmp_url}" "https://thepiratebay.party/search/${query}/1/99/200"
    local i=0
    while grep -E -C3 -m1 -e 'magnet:\?' > "${tmp_entry}"; do
	IFS="$(printf '\x01')" read -r descr date size seeds leechs \
	   <<< "$(grep -Eoe '>[^<]+<' ${tmp_entry} | tr -d '><' | sed 's/\&amp;/&/ ; s/\&nbsp;/ /' | tr '\n' '\001')"
	link=$(grep -Eoe 'magnet:\?[^"]*' ${tmp_entry})
	printf "%s\x01" "${descr}" "${size}" "${seeds}" "${leechs}" "${link}" >> $entries
	echo >> $entries

	# Here for compliance with --max-sites option.
	((i++))
	((i==${max_sites})) && break
    done < "${tmp_url}" 
}
