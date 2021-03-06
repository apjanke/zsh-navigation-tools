#!/bin/sh

#
# Clone or pull
#

if ! test -d ~/.config; then
    mkdir ~/.config
fi
if ! test -d ~/.config/znt; then
    mkdir ~/.config/znt
fi

echo ">>> Downloading zsh-navigation-tools to ~/.config/znt"
if test -d ~/.config/znt/zsh-navigation-tools; then
    cd ~/.config/znt/zsh-navigation-tools
    git pull origin master
else
    cd ~/.config/znt
    git clone https://github.com/psprint/zsh-navigation-tools.git zsh-navigation-tools
fi
echo ">>> Done"

#
# Copy configs
#

echo ">>> Copying config files"

cd ~/.config/znt

set n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf n-preview.conf

for i; do
    if ! test -f "$i"; then
        cp -v zsh-navigation-tools/.config/znt/$i .
    fi
done

echo ">>> Done"

#
# Modify .zshrc
#

echo ">>> Updating .zshrc"
if ! grep zsh-navigation-tools ~/.zshrc >/dev/null 2>&1; then
    echo >> ~/.zshrc
    echo "### ZNT's installer added snippet ###" >> ~/.zshrc
    echo "fpath=( \"\$fpath[@]\" \"\$HOME/.config/znt/zsh-navigation-tools\" )" >> ~/.zshrc
    echo "autoload n-aliases n-cd n-env n-functions n-history n-kill n-list n-list-draw n-list-input n-options n-panelize" >> ~/.zshrc
    echo "autoload znt-usetty-wrapper znt-history-widget znt-cd-widget" >> ~/.zshrc
    echo "alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history" >> ~/.zshrc
    echo "alias nkill=n-kill noptions=n-options npanelize=n-panelize" >> ~/.zshrc
    echo "zle -N znt-history-widget" >> ~/.zshrc
    echo "bindkey '^R' znt-history-widget" >> ~/.zshrc
    echo "setopt AUTO_PUSHD HIST_IGNORE_DUPS PUSHD_IGNORE_DUPS" >> ~/.zshrc
    echo "### END ###" >> ~/.zshrc
    echo ">>> Done"
else
    echo ">>> .zshrc already updated, not making changes"
fi
