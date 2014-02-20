source /opt/boxen/env.sh

# (l)ong, (a)ll, (p)ath marked, (h)uman numbers, (t)ime sorted, (r)everse sort
alias ll='ls -laph'
alias lt='ls -laphtr'

# A sorta short version of tree which only shows 2 levels of folders
alias bush='tree -d -L 2 -I "__pycache__|.hg|.DS_Store|htmlcov|.hgcheck|src"'
alias tree='tree -a -I "__pycache__|.hg|.DS_Store|htmlcov|.hgcheck|src" --dirsfirst'
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
alias op='lsof -i -P | grep -v -e ^Microsoft -e ^Dropbox -e ^BetterTou -e ^HipChat -e ^GitHub -e ^Google -e ^Finder -e ^Office365'

# Tell me What Is Going On
alias wigo='python -V; pyenv version'

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
