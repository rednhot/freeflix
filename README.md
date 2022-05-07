<h1 align="center">freeflix</h1>

<p align="center">Like netflix, but it's free. Surf torrent sites for disered movies & tv shows and watch them immediately.</p>

-------------------------------------------------------------------------------

<p align="center">
<img src="./preview.gif" alt="Video Preview" width="500px">
</p>


## How does this work? ##

`freeflix` searchs configurable torrent site for torrents(surprisingly), allowing a user to choose one which suits the most(like having more seeds, or having a better quality). After choosing one, it passes that **magnet** link to selectable backend, such as `peerflix`, and a video starts to play.

Since backend and its options can be configured easily, you can use `freeflix` for pretty much any content that is shared on bittorrent network.

Also, `freeflix` has a modular design, allowing users/developers to choose from/add support for multiple torrent sites. That aids in remaining independent of a particular torrent site, in case it goes down for some reason.

## Requirements ##

* [peerflix](https://github.com/mafintosh/peerflix) - A tool to stream torrent. `sudo npm install peerflix -g` 
* [dmenu](https://tools.suckless.org/dmenu) - A simple menu program. `sudo apt install suckless-tools`

## Optional ##

* [vlc](https://github.com/videolan/vlc) - VLC media player. `sudo apt install vlc`

### Installation ###

``` sh
$ sudo mkdir -p /usr/local/bin
$ sudo curl -sL https://raw.githubusercontent.com/rednhot/freeflix/main/freeflix -o /usr/local/bin/freeflix
$ sudo chmod +x /usr/local/bin/freeflix
$ [[ "$PATH" != */usr/local/bin* ]] && echo 'PATH=/usr/local/bin:"$PATH"' >> ~/.bashrc
$ source ~/.bashrc
```

### Usage ###

``` sh
$ ./freeflix -h
Usage: ./freeflix [options...] description
        -B, --backend <backend>         Backend to use for magnet link.
        -l, --listsites                 Use currently supported torrent sites.
        -f, --fast                      Alias for --max-torrents 1.
        -J, --justdoit                  Use defaults that just work. Most probably you want it.
        -s, --site <torrent site>       Select torrent site from which to fetch magnet links.
        -h, --help                      Show help.
        -v, --verbose                   Turn on verbose mode.
        -m, --max-links <n>             Show maximum of n torrents.
        -W, --backend-opt <option>      Pass option to backend.
```

### Examples ###
  * `freeflix -J Breaking Bad Season 1`  ----- Watch a cool tv series about junkies using *vlc*.
  * `freeflix -f -s piratebay -B echo Spider man 2002` ----- Just print first magnet link on **piratebay** for good old Spider Man with Maguire.
  * `freeflix --max-torrents 10 --site 1337x -B qbittorrent Peppa pig` ----- Parse only 10 torrents on 1337x and after selecting start *qbittorrent* with that magnet.
  * `freeflix -s 1337x -B qbittorrent -m 100 Heroes of Might and Magic 3` ----- Download one of the best strategic games ever.

### Extension ###
Since `freeflix` is just a series of parse functions, each specific to a torrent site, they have to share the same interface in order to work properly together.

#### Input ####

  * `query` shell variable containing user's query

  * `max_sites` shell variable, telling the maximum number of processed torrent links

#### Output ####

Parse function should fill file, pointed by `entries` shell variable, with torrent entries, delimited by newline.
Each entry has the following format: `Description\x01Size\x01Seeds\x01Leechs\x01Magnet_link`, that is items delimited by byte with value of 1.
For example:
``` sh
printf "%s\x01" "$descr" "$size" "$seeds" "$leechs" "$magnet_link" >> $entries
```

Also, you have to add a mapping to `sites` shell variable between convenient torrent site name and corresponding shell function handler.
For example:

``` sh
sites["1337x.wtf"]="1337x"
```

### TODO ###

  * Add support for more sites.

#### License ####

This project is licensed under [GPL-3.0](https://raw.githubusercontent.com/Illumina/licenses/master/gpl-3.0.txt).

