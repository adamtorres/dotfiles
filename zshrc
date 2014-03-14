# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="at"

echo "Warning! zort, clean, cover, coverorb, and pylinks do not yet work in zsh."

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ag="nocorrect ag"
alias p="pip install --no-index --find-links=file://${HOME}/.pip-packages/ --exists-action w"
alias pc="pip install --download ${HOME}/.pip-packages --exists-action w"
# alias pip="echo 'Use p to install and pc to cache' ; pip \!*"
alias s="python -m SimpleHTTPServer"
alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"

django () {
  case $* in
    console* ) shift; command python manage.py shell "$@" ;;
    dbconsole* ) shift; command python manage.py dbshell "$@" ;;
    deps* ) shift; pc -r requirements.txt "$@" ;;
    new* ) shift; command django-admin.py startproject "$@" ;;
    reset* ) shift; command python manage.py reset_db --router=default && p -U -r requirements.txt && python manage.py syncdb --migrate --noinput ;;
    server* ) shift; command python manage.py runserver_plus "$@" ;;
    * ) command python manage.py "$@" ;;
  esac
}

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
alias op='lsof -i -P | grep -v -e ^Microsoft -e ^Dropbox -e ^BetterTou -e ^HipChat -e ^GitHub -e ^Google -e ^Finder -e ^Office365'

# Tell me What Is Going On
alias wigo='echo "look at the right side prompt"'

# alias hgl="hg log --template '{rev} | {node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\\n' | less"
alias hgll="hg log -G -l9 --template 'changeset:   {rev}:{node|short}\\nbranch:      {branch}\\nparent:      {p1rev}:{p1node|short}{ifeq(p2rev, \"-1\", \"\", \", {p2rev}:{p2node|short}\")}\\nuser:        {author}\\ndate:        {date}\\ndescription: {desc}\\n\\n' | less"
function hgv() {
    # Get the working set revision number for all hg repos starting at the current location.
    # This is a function because I couldn't get the quotes to be happy in an alias.
    find . -name .hg -exec bash -c 'var={}; var=${var%/*}; pushd $var > /dev/null; rev=`hg identify --num`; branch=`hg branch`; echo -e "$rev\t$var\t$branch"; popd > /dev/null;' \; | expand -t 10,50
}

#Combines mkdir and cd commands.
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# Get syntax highlighting on less command.
# need to run 'brew install source-highlight'
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS='-R'

# [[ -s ~/.autojump/etc/profile.d/autojump.bash ]] && . ~/.autojump/etc/profile.d/autojump.bash

# [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

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

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git mercurial python)

source $ZSH/oh-my-zsh.sh

# Boxen bootstrap
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
