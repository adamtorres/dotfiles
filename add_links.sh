#! /usr/bin/env bash
# TODO: Is this really any better than 8 lines of "ln -s" commands?

function make_link() {
	if [[ -s ~/.$1 ]]; then
		echo "$1 exists.  You need to compare it to ~/.dotfiles/$1 to verify nothing would be lost, remove .$1, and try again."
	else
		echo "$1 does not exist.  Creating link."
		ln -s ~/.dotfiles/$1 ~/.$1
	fi
}

declare -a dotfiles=(
	"profile"
	"gitconfig"
	"gitignore_global"
	"hgignore_global"
	"hgrc"
	"pdbrc"
	"psqlrc"
	"vimrc"
	)

for r in "${dotfiles[@]}"
do
	make_link "$r"
done
