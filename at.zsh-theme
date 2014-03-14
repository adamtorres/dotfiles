autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git hg svn

zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' get-revision true
zstyle ':vcs_info:*:prompt:*' formats       "%{$fg[white]%}on%{$reset_color%} %{$fg[magenta]%}%s%{$reset_color%}%{$fg[white]%}:%{$reset_color%}%{$fg[blue]%}%b%{$reset_color%}%{$fg[red]%}%m%u%c%{$reset_color%} "
zstyle ':vcs_info:*:prompt:*' actionformats "%{$fg[white]%}on%{$reset_color%} %{$fg[magenta]%}%s%{$reset_color%}%{$fg[white]%}:%{$reset_color%}%{$fg[blue]%}%b%{$reset_color%}%{$fg[red]%}%m%u%c%{$reset_color%} [%{$fg_bold[red]%}%a%{$reset_color%}] "

zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes

zstyle ':vcs_info:hg:prompt:*' hgrevformat "%r" # only show local rev.
zstyle ':vcs_info:hg:prompt:*' branchformat "%b" # only show branch

zstyle ':vcs_info:git*+set-message:prompt:*' hooks check-untracked
zstyle ':vcs_info:hg*+set-message:prompt:*'  hooks check-untracked

function +vi-check-untracked() {
    local has_untracked
    local has_untracked_hg
    local has_untracked_git

    has_untracked=''

    has_untracked_hg=$(hg status 2>/dev/null | grep '^\?')
    if [[ -n ${has_untracked_hg} ]] ; then
        has_untracked='⁰'
    fi

    has_untracked_git=$(git status 2>/dev/null | grep '\(# Untracked\)')
    if [[ -n ${has_untracked_git} ]] ; then
        has_untracked='⁰'
    fi

    hook_com[misc]+=${has_untracked}
}

precmd() {
    vcs_info 'prompt'
}

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'
local current_vcs='${vcs_info_msg_0_}'

local node_version='$(/opt/boxen/nodenv/bin/nodenv version | sed -e "s/ (set.*$//")'
local python_version='$(/opt/boxen/pyenv/bin/pyenv version-name)'
local ruby_version='$(/opt/boxen/rbenv/bin/rbenv version-name)'

# Prompt format: \n # USER at MACHINE in DIRECTORY on git:BRANCH STATE [TIME] \n $ 
PROMPT="
%{$fg_bold[blue]%}# %{$fg[cyan]%}%n%{$fg[white]%}@%{$fg[green]%}$(box_name) %{$reset_color%}${current_vcs}%{$fg[white]%}in \
%{$fg_bold[yellow]%}${current_dir}%{$reset_color%}
%{$fg_bold[red]%}$ %{$reset_color%}"

# Right-side prompt: python/ruby versions
RPROMPT="%{$fg[gray]%}[N:${node_version}] [P:${python_version}] [R:${ruby_version}]%{$reset_color%} %{$fg[white]%}[%*]%{$reset_color%}"
