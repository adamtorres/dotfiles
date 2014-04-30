source /opt/boxen/env.sh
export PATH=$PATH:/opt/wkhtmltopdf/bin

# (l)ong, (a)ll, (p)ath marked, (h)uman numbers, (t)ime sorted, (r)everse sort
alias ll='ls -laph'
alias lt='ls -laphtr'

# A sorta short version of tree which only shows 2 levels of folders
alias bush='tree -d -L 2 -I "__pycache__|.hg|.git|.DS_Store|htmlcov|.hgcheck|src"'
alias tree='tree -a -I "__pycache__|.hg|.git|.DS_Store|htmlcov|.hgcheck|src" --dirsfirst'
alias realtree='/opt/boxen/homebrew/bin/tree'

# Removes cached python files
alias clean='find . -name *.pyc -delete && find . -type d -name __pycache__ -delete'

# Run coverage.  If no errors, build html report and open in default browser.
# The omit option removes third party libraries from the report.
# Include orb
alias coverorb='coverage run --omit=/opt/boxen/pyenv*,tests/*,src/* -m unittest discover ; coverage html ; open htmlcov/index.html'
# Exclude orb
alias cover='coverage run --omit=/opt/boxen/pyenv*,tests/*,src/*,../orb/* -m unittest discover ; coverage html ; open htmlcov/index.html'

# Find and show all links to source being used by pyenv versions.
# Output is the path/name of the egg-link and the contents showing where the link is pointing.
# Useful for spotting links pointing to silly locations.
alias pylinks="find /opt/boxen/pyenv/versions -iname *.egg-link -exec sh -c 'echo {}; cat {}; echo' \;"

# Simple shortcut to ssh into the dev server.
alias gogodev='ssh ubuntu@staging.amplify-nation.com'

# List open network connections while hiding the ones from boring applications and such we likely don't care about.
alias op='lsof -i -P | grep -v -e ^Microsoft -e ^Dropbox -e ^BetterTou -e ^HipChat -e ^GitHub -e ^Google -e ^Finder -e ^Office365 -e ^firefox -e ^sharingd -e ^SystemUIS -e UserEvent -e ^ARDAgent'

# List the running python scripts.  The [p] seems to remove the 'grep' from the output rather than having to pipe again to 'grep -v grep'.
alias running='ps aux | grep [p]ython'

# Tell me What Is Going On
alias wigo='python -V; pyenv version'

# Tell me What Is Really Going On
alias wirgo='printf "\nEnvironment:\n"; wigo; printf "\nRunning Scripts:\n"; running; printf "\nOpen Ports:\n"; op;'

# Git Alias's
alias glt="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gtb="git branch"
alias gcm="git commit"

# hg Alias's
alias hgs="hg status"
alias hgb="hg branch"
alias hgbs="hg branches"
alias hgl="hg log --template '{rev} | {node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\\n' | less"
alias hgll="hg log -G -l9 --template 'changeset:   {rev}:{node|short}\\nbranch:      {branch}\\nparent:      {p1rev}:{p1node|short}{ifeq(p2rev, \"-1\", \"\", \", {p2rev}:{p2node|short}\")}\\nuser:        {author}\\ndate:        {date}\\ndescription: {desc}\\n\\n' | less"
alias hgco="hg checkout"
alias hgcm="hg commit"
function hgv() {
    # Get the working set revision number for all hg repos starting at the current location.
    # This is a function because I couldn't get the quotes to be happy in an alias.
    find . -name .hg -exec bash -c 'var={}; var=${var%/*}; pushd $var > /dev/null; rev=`hg identify --num`; branch=`hg branch`; echo -e "$rev\t$var\t$branch"; popd > /dev/null;' \; | expand -t 10,50
}

# Not exactly the same as lsusb but does what I need when I think of lsusb.
# That is, list the usb devices.
alias lsusb='system_profiler SPUSBDataType'

# (\t)ime (\w)orking directory (\n)ewline (\u)ser@(\h)ost
export PS1="\t \w\n\u@\h: "

#Combines mkdir and cd commands.
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# Get syntax highlighting on less command.
# need to run 'brew install source-highlight'
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS='-R'

#[[ -s ~/.autojump/etc/profile.d/autojump.bash ]] && . ~/.autojump/etc/profile.d/autojump.bash

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

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

function ytdl() {
    if [ "x$1" == "x" ]; then
        echo ""
        echo "youtube-dl shortcut usage:"
        echo "  ytdl [url]"
        echo "Will convert to:"
        echo "  youtube-dl --max-quality mp4 --write-info-json --write-description [url]"
        echo ""
        exit 1
    else
        echo "youtube-dl --max-quality mp4 --write-info-json --write-description $1"
        youtube-dl --max-quality mp4 --write-info-json --write-description $1
    fi
}

function mp4to3() {
    if [ "x$1" == "x" ]; then
        echo ""
        echo "mp4to3 [filename.mp4]"
        echo ""
        exit 1
    fi
    OUT_FILE=`echo "$1" | sed 's/\.[^\.]*$/.mp3/'`
    /Applications/VLC.app/Contents/MacOS/VLC -I dummy "$1" --sout='#transcode{acodec=mp3,vcodec=dummy}:standard{access=file,mux=raw,dst="$(echo "$OUT_FILE")"}' vlc://quit
}

# Sets the terminal title to whatever is passed in.
function set_title() {
    echo -ne "\033]0;$@\007"
}
# for file in /Users/$USER/Music/*.mp4;
# do
#     /Applications/VLC.app/Contents/MacOS/VLC -I dummy "$file" --sout="#transcode{acodec=mp3,vcodec=dummy}:standard{access=file,mux=raw,dst=\"$(echo "$file" | sed 's/\.[^\.]*$/.mp3/')\"}" vlc://quit;
# done

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

# Apply settings for SOS apps
. ~/.sos_init
