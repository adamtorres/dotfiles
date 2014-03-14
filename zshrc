# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="at"

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
plugins=(git ruby python)

source $ZSH/oh-my-zsh.sh

# Boxen bootstrap
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
