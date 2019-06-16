# Just a bogus change to test something

# brew install pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# brew install pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

#### Do not have ruby installed?
# export RBENV_ROOT='/opt/rbenv'
# eval "$(rbenv init -)"

# brew install findutils
# export MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"

# Trying to not install things like this on the bare metal os.
# export PATH=$PATH:/opt/wkhtmltopdf/bin:/opt/ngrok:/opt/utils
# export PATH=$PATH:/opt/mongodb/bin:/opt/redis/bin

# No clue why this happened but java command line failed at some point.
# Have to manually set this.
# export JAVA_HOME="/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/"

# (l)ong, (a)ll, (p)ath marked, (h)uman numbers, (t)ime sorted, (r)everse sort
alias ll='ls -laph'
alias lt='ls -laphtr'

# brew install tree
# A sorta short version of tree which only shows 2 levels of folders
alias bush='tree -d -L 2 -I "__pycache__|.hg|.git|.DS_Store|htmlcov|.hgcheck|src"'
alias tree='tree -a -I "__pycache__|.hg|.git|.DS_Store|htmlcov|.hgcheck|src|.idea" --dirsfirst'
alias realtree='/usr/local/bin/tree'

# TODO: Does this need findutils installed?
# Removes cached python files
alias clean='find . -name *.pyc -delete && find . -type d -name __pycache__ -delete && find . -name *.*.orig -delete'

# Compress and decompress txt files inplace.  Removes original file.  One file per compressed file.
# Made for compressing many daily/history files so each is its own compressed file.
alias comptxt="find . -type f -iname '*.txt' -print -exec gzip {} \;"
alias uncomptxt="find . -type f -iname '*.txt.gz' -print -exec gunzip {} \;"

# Find and show all links to source being used by pyenv versions.
# Output is the path/name of the egg-link and the contents showing where the link is pointing.
# Useful for spotting links pointing to silly locations.
alias pylinks="find $PYENV_ROOT/versions -iname *.egg-link -exec sh -c 'echo {}; cat {}; echo' \;"

# TODO: Verify this against Django 2+
# Show missing migrations.  Output will be a list of all apps and only migrations which have not been run.
alias mm='./manage.py showmigrations | grep -v -e "\[\X\]" -e "\(\*\)"'

# List open network connections while hiding the ones from boring applications and such we likely don't care about.
alias op='lsof -n -i -P | grep -v -e ^Microsoft -e ^Dropbox -e ^GitHub -e ^Google -e ^Finder -e ^Office365 -e ^firefox -e ^sharingd -e ^SystemUIS -e UserEvent -e ^ARDAgent -e ^Slack -e ^WiFi -e ^com\.apple'

# Cuts stdin to width out terminal as reported by 'tput cols'.  Subtracts 5 to give a little gap.  Works in pipes
alias ctw='cut -c1-$(($(tput cols)-5))'

# Excludes the 32 character queues added by celery chords.
alias exclude_chords='grep -v -E "[a-z0-9]{32}"'

# Flush DNS with a hammer.
alias fdns='sudo killall -HUP mDNSResponder'
# alias fdns='sudo dscacheutil -flushcache'

# List the running python scripts.  The [p] seems to remove the 'grep' from the output rather than having to pipe again to 'grep -v grep'.
alias running='ps aux | grep [p]ython'
# function pidof() {
#     # PIDS=`ps ax | grep -i "$1" | grep -v "grep -i" | awk "{ print \$1 }" | tr '\n' ' '`
#     PIDS=`ps ax | awk "{if(index(\$5, \"$1\")>0) print \$1}" | tr '\n' ' '`
#     echo "Found these $PIDS"
# }

# TODO: Are these really necessary if I try to not install any services locally?  Possibly the wi* might be ok.
# Tell me What Is Going On
alias wigo='python -V; pyenv version'
# Tell me What Is Really Going On
alias wirgo='printf "\nEnvironment:\n"; wigo; printf "\nRunning Scripts:\n"; running; printf "\nOpen Ports:\n"; op;'
# What is running.  shows the various bits likely involved with the project.
alias wir='(ps -ef | head -n 1; ps -ef | grep -E -e "(celery|uwsgi|nginx|python)" | grep -v "(celery|uwsgi|nginx|python)" | sort -k8 | cut -c1-250)'

# Keep a pg password in the env without having it show in command history or in a file.
alias cache_pgpassword='read -s -p "Enter something> " PGPASSWORD; export PGPASSWORD; echo .'

# Git Alias's
alias glt="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gtb="git branch"
alias gcm="git commit"

# hg Alias's
alias hgd='hg diff | grep "^[!-+]"'
alias hgs="hg status"
alias hgss='hgs | grep "^[^?]"'
alias hgb="hg branch"
alias hgbs="hg branches | sort"
alias hgl="hg log --template '{rev} | {node|short} | {date|isodatesec} | {author|user} | {branch} | {desc|strip|firstline}\\n'"
alias hgll="hg log -G -l9 --template 'changeset:   {rev}:{node|short}\\nbranch:      {branch}\\nparent:      {p1rev}:{p1node|short}{ifeq(p2rev, \"-1\", \"\", \", {p2rev}:{p2node|short}\")}\\nuser:        {author}\\ndate:        {date|isodatesec}\\ndescription: {desc}\\n\\n' --stat"
alias hglll="hg log -G -l9 --template 'changeset:   {rev}:{node}\\nbranch:      {branch}\\nparent:      {p1rev}:{p1node}{ifeq(p2rev, \"-1\", \"\", \", {p2rev}:{p2node}\")}\\nuser:        {author}\\ndate:        {date|isodatesec}\\ndescription: {desc}\\n\\n' --stat"
function hglm() {
    echo "Looking for merges in $(hg branch)."
    echo "rev | node | p1rev | p2rev | branch | date | user | desc_first_line";
    hg log --template '{rev} | {node|short} | {p1rev} | {p2rev} | {branch} | {date|isodatesec} | {author|user} | {desc|strip|firstline}\n' --limit 50 --branch "$(hg branch)" | grep -i ' | merge '
}
alias hgld="hg log --template '{rev} | {node|short} | {branch} | {date|isodatesec} | {author|user} | {desc|strip|firstline}\n' --limit 10 --branch default"
alias hgco="hg checkout"
alias hgcm="hg commit"
function hgv() {
    # Get the working set revision number for all hg repos starting at the current location.
    # This is a function because I couldn't get the quotes to be happy in an alias.
    find . -name .hg -exec bash -c 'var={}; var=${var%/*}; pushd $var > /dev/null; revnum=`hg identify --num`; revid=`hg identify --id`; branch=`hg branch`; echo -e "$revid\t$revnum\t$var\t$branch"; popd > /dev/null;' \; | expand -t 15,23,60
}
alias hgf="hg flow"
alias hgfr="hg flow release start"
alias hgfh="hg flow hotfix start"
alias hgff="hg flow feature start"
alias hgflr='hg branches --closed | grep -i "^release"'
alias hgflh='hg branches --closed | grep -i "^hotfix"'
alias hgflf='hg branches --closed | grep -i "^feature"'

# What Have I Done!?  Compares current to the ancestor. The inner 'hg log' attempts to find the parent.  That should result in 'develop' or 'default'.
function whid() {
    hg diff -r $(hg id --num -r $(hg log -r "max(ancestors($(hg branch)) and not branch($(hg branch)))" --limit 1 --template '{branch}'))
}

# Nice idea but not reliable.  Seems to follow only the current branch's history.
# # What Did I Do?
# alias wdid='wdsd atorres@amplify-nation.com'
#
# # What Did Somebody Do?
# function wdsd () {
#     hg log -u "$1" --template "{rev} | {node|short} | {date|isodatesec} | {author|user} | {branches}\n\t{desc|strip|tabindent}\n" --date ">yesterday"
# }

# Show comments in the current branch.  Helpful to spot commented debug code and inappropriate comments.
function find_comments() {
    hg diff -r $(hg id --num -r $(hg log -r "max(ancestors($(hg branch)) and not branch($(hg branch)))" --limit 1 --template '{branch}')) | grep -E -e "^\+ +#" -e "^diff"
}

# Experimental function to cycle through listed repos and update each.
function uphg() {
    declare -a repos=(
    "repo1"
    "repo2"
    )

    for r in "${repos[@]}"
    do
        echo "========================================="
        echo "Processing $r"
        pushd ~/Projects/$r > /dev/null
        hg pull -u
        b=`hg branch`
        echo "Currently on branch '$b'"
        popd > /dev/null
        echo ""
    done
}

# Not exactly the same as lsusb but does what I need when I think of lsusb.
# That is, list the usb devices.
alias lsusb='system_profiler SPUSBDataType'

# (\t)ime (\w)orking directory (\n)ewline (\u)ser@(\h)ost
export PS1="\t \w\n\u@\h: "

# Combines mkdir and cd commands.
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# brew install source-highlight
# Get syntax highlighting on less command.
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS='-R'

# brew install autojump
# Allows jumping to frequently used directories
#[[ -s ~/.autojump/etc/profile.d/autojump.bash ]] && . ~/.autojump/etc/profile.d/autojump.bash
# [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

function hnt() {
    # Head N Tail
    echo "head $1"
    head "$1"
    echo "tail $1"
    tail "$1"
}

# Search a single file or all files for class/def and show sorted output.
function zort() {
    if [ "x$1" == "x" ]; then
        (ag "def " -w -G "\.py$"; ag "class " -w -G "\.py$") | sort -t : -k 1,1 -k 2,2g
        # echo "Searched all"
    else
        (ag "def " $1 -w; ag "class " $1 -w) | sort -t : -k 1,1g
        # echo "Searched one"
    fi
}


# brew install youtube-dl
# command line download of youtube videos
function ytdl() {
    if [ "x$1" == "x" ]; then
        echo ""
        echo "youtube-dl shortcut usage:"
        echo "  ytdl [url]"
        echo "Will convert to:"
        echo "  youtube-dl --max-quality mp4 [url]"
        echo ""
        exit 1
    else
        echo "youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' $1"
        # youtube-dl --max-quality mp4 --write-info-json --write-description $1
        youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' $1
    fi
}

function ytdlm() {
    if [ "x$1" == "x" ]; then
        echo ""
        echo "youtube-dl (for music) shortcut usage:"
        echo "  ytdlm [url]"
        echo "Will convert to:"
        echo "  youtube-dl -f 'bestaudio[ext=m4a]/best[ext=mp4]/best' [url]"
        echo ""
        exit 1
    else
        echo "youtube-dl -f 'bestaudio[ext=m4a]/best[ext=mp4]/best' $1"
        youtube-dl -f 'bestaudio[ext=m4a]/best[ext=mp4]/best' $1
    fi
}

# brew install homebrew/cask/vlc
function mp4to3() {
    if [ "x$1" == "x" ]; then
        echo ""
        echo "mp4to3 [filename.mp4]"
        echo ""
        exit 1
    fi
    OUT_FILE=`echo "$1" | sed 's/\.[^\.]*$/.mp3/'`
    echo "OUT_FILE='$OUT_FILE'"
    /Applications/VLC.app/Contents/MacOS/VLC -I dummy "$1" --sout='#transcode{acodec=mp3,vcodec=dummy}:standard{access=file,mux=raw,dst="this_is_a_temp_file.mp3"}' vlc://quit
    mv this_is_a_temp_file.mp3 "$OUT_FILE"
}

function mp3towav() {
    if [ "x$1" == "x" ]; then
        echo ""
        echo "mp3towav [filename.mp3]"
        echo ""
        exit 1
    fi
    OUT_FILE=`echo "$1" | sed 's/\.[^\.]*$/.wav/'`
    echo "OUT_FILE='$OUT_FILE'"
    /Applications/VLC.app/Contents/MacOS/VLC -I dummy "$1" --no-sout-video --sout-audio --no-sout-rtp-sap --no-sout-standard-sap --ttl=1 --sout-keep --sout '#transcode{acodec=s16l,channels=2,samplerate=44100}:std{access=file,mux=wav,dst="this_is_a_temp_file.wav"}' vlc://quit
    mv this_is_a_temp_file.wav "$OUT_FILE"
}

function wavtomp3() {
    if [ "x$1" == "x" ]; then
        echo ""
        echo "wavtomp3 [filename.wav]"
        echo ""
        exit 1
    fi
    OUT_FILE=`echo "$1" | sed 's/\.[^\.]*$/.mp3/'`
    echo "OUT_FILE='$OUT_FILE'"
    /Applications/VLC.app/Contents/MacOS/VLC -I dummy "$1" --no-sout-video --sout-audio --no-sout-rtp-sap --no-sout-standard-sap --ttl=1 --sout-keep --sout '#transcode{acodec=mp3,channels=2,samplerate=44100}:std{access=file,mux=raw,dst="this_is_a_temp_file.mp3"}' vlc://quit
    mv this_is_a_temp_file.mp3 "$OUT_FILE"
}

# Specifically for hickok45's radio shows.  He has stopped those and switch to another format.
# TODO: Figure out if this needs changed.
function radioshow() {
    if [ "x$2" == "x" ]; then
        echo ""
        echo "radioshow [url] [number]"
        echo ""
        exit 1
    fi

    KEEP_VIDEO="Yes"
    if [ "x$3" == "xkeep-video" ]; then
        KEEP_VIDEO="No"
    fi

    MP4_FILE=`youtube-dl --get-filename --output "RadioShow-$2-%(upload_date)s.%(ext)s" $1`
    echo "MP4_FILE='$MP4_FILE'"

    youtube-dl --continue --format mp4 --output "$MP4_FILE" $1
    mp4to3 $MP4_FILE
    if [ "$KEEP_VIDEO" == "No" ]; then
        rm $MP4_FILE
    fi
}

# Sets the terminal title to whatever is passed in.
function set_title() {
    echo -ne "\033]0;$@\007"
}

# An attempt to keep the terminal title to the project's name instead of the last directory in the chain.
# TODO: Not sure if this is still useful.
# function get_project() {
#     tmp=${PWD#$HOME/Projects/APCO-SOS/}
#     if [ "$tmp" == "$PWD" ]; then
#         echo -n ${PWD#$HOME/}
#     else
#         # With subdirs
#         # echo -n $tmp
#         # Without subdirs
#         echo -n "${tmp%%/*}"
#     fi
# }
# export PROMPT_COMMAND='set_title `get_project`'
# export PROMPT_COMMAND='echo -ne "\033]0;`get_project`\007"'

# Find the most recent PG log file and tail/follow it.
# TODO: Not likely useful as I'm trying to not install things like this on the bare metal os.
# function tailpg() {
#     (ls -1t ~/Projects/APCO-SOS/logs/postgres/postgresql*.log | head -n 1 && tail -F $(ls -1t ~/Projects/APCO-SOS/logs/postgres/postgresql*.log | head -n 1))
#     # (ls -1t /usr/local/var/postgres/pg_log/postgresql*.log | head -n 1 && tail -F $(ls -1t /usr/local/var/postgres/pg_log/postgresql*.log | head -n 1))
#     # tail -f $(ls -1tr /opt/boxen/data/postgresql-9.4/pg_log/postgresql-* | tail -n 1)
# }

# idea: simple find/replace function to make it easier to do rather than
# always having to google for methods.
# find . -type f -name '$PATTERN' -exec sed -i '' 's/$OLD/$NEW/g' {} +

# sha1/md5 hashing
# openssl sha1 [filename]
# md5 [filename]

# Nifty brace expansion
# mv name.{txt,bak}
# renames name.txt to name.bak
# echo {1..5}
# echos "1 2 3 4 5"
# echo {1,5}
# echos "1 5"

function show_settings(){
    # Only shows the lines in a file which do not begin with '#'.
    # For lines which don't begin with '#', will strip off any trailing comments - looks for the first '#' and includes preceeding whitespace.
    # '#' could have preceeding whitespace.
    # Sorts output.  This could be used to diff settings in config files.
    grep -v -E -e "^[[:space:]]*[#]" -e "^$" "$1" | sed -e "s/[[:space:]]*#.*$//" -e "s/[[:space:]]*$//" | sort
}

# iterm shell integration didn't work nice.
# Random stack exchange showed this and it worked.  Would need to work up something to tell when ssh starts and switch.
# echo -e "\033]50;SetProfile=ampops\a"

function space_used() {
    echo "Docker"; du -d 1 -h ~/Library/Containers/com.docker.docker/Data;
    # plus any other common places that eat up space.
}

function rand_str() {
    # Lifted and modified from https://gist.github.com/earthgecko/3089509
    len=$(echo "$1" | sed 's/[^0-9]*//g')
    if [ "z$len" == "z" ]; then
        len=32
    fi
    echo "rndstr:$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w "$len" | head -n 1)"
}

# How to install?
# Opting out of .NET Core 1.1's "send data to MS" feature
# DOTNET_CLI_TELEMETRY_OPTOUT=1

# When extra characters show up when pasting, run this to turn it off.
# Ex: copied "DATA", pasted "01~DATA~00".
alias paste_extra_chars="printf '\e[?2004l'"
