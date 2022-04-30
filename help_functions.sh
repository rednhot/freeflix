#!/bin/bash

# Cool function. Most probably not used :)
yesno()
{
    [ -z "$1" ] && echo 1
    echo "$1" | sed -n '/yes/Iq1 ; /true/Iq1 ; /on/Iq1' && echo 1 || echo 0
}

warn()
{
    echo "Warning: $*" >&2
}

err()
{
    echo "Error: $*"
    clean_tmp
    exit 1
}

# Remove all temporary files that were generated during execution
clean_tmp()
{
    [ "${verbose}" = '1' ] && rm -rfv "$tmpdir" || rm -rf "$tmpdir"
}

# Exit in a clean way
clean_exit()
{
    clean_tmp
    echo "Goodbye!"
    exit 0
}

# Show help
show_help()
{
    local opts
    declare -A opts
    printf "Usage: $1 [options...] description\n"
    opts["-s, --site <torrent site>"]="Select torrent site from which to fetch magnet links."
    opts["-l, --listsites"]="Use currently supported torrent sites."
    opts["-m, --max-sites n"]="Show maximum of n torrents."
    opts["-f, --fast"]="Alias for --max-torrents 1."
    opts["-J, --justdoit"]="Defaults that just work."
    opts["-W, --backend-opt <option>"]="Pass option to backend."
    opts["-B, --backend <backend>"]="Backend to use for magnet link."
    opts["-v, --verbose"]="Turn on verbose mode."
    opts["-h, --help"]="Show help."
    for o in "${!opts[@]}"; do
	printf "\t%-30s\t%s\n" "$o" "${opts[$o]}"
    done
}

# Since torrent sites can represent some text in
# non-ascii encoding, here we do some magic to make output more appealing to see.
clength() { clength=${#1}; }
blength() { local LC_ALL=C; blength=${#1}; }
align() {
  local width="$1" arg="$2" blength clength
  clength "$arg"; blength "$arg"
  local i
  if ((clength <= width)) ; then
      printf "%s%*s" "$arg" "$((width - clength))" ""
  else
      for ((i=0; i < width; i++)) ; do
	      printf "%s" "${arg:$i:1}"
	  done
  fi
}
