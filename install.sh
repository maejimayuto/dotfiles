#!/bin/bash

set -u
DOT_CONFIG_DIRECTORY="${HOME}/work/settings"
DOT_DIRECTORY="dotfiles"

echo "link .config directory dotfiles"
cd ${DOT_CONFIG_DIRECTORY}/${DOT_DIRECTORY}/
for f in .??*
do
    #無視したいファイルやディレクトリ
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    ln -snfv ${DOT_CONFIG_DIRECTORY}/${DOT_DIRECTORY}/${f} ${HOME}/${f}
done

echo "linked dotfiles complete!"


#######################################
# シンボリックリンクの作成
#######################################

# ln -snfv ~/work/settings/dotfiles/.gitattributes_global /Users/maejimayuto/.gitattributes_global
# ln -snfv ~/work/settings/dotfiles/.gitconfig /Users/maejimayuto/.gitconfig
# ln -snfv ~/work/settings/dotfiles/.gitignore_global /Users/maejimayuto/.gitignore_global
# ln -snfv ~/work/settings/dotfiles/.tmux.conf /Users/maejimayuto/.tmux.conf
# ln -snfv ~/work/settings/dotfiles/.zshrc /Users/maejimayuto/.zshrc
# ln -snfv ~/work/settings/dotfiles/.zsh_history /Users/maejimayuto/.zsh_history
# ln -snfv ~/work/settings/dotfiles/.Brewfile /Users/maejimayuto/Brewfile
# ln -snfv ~/work/settings/dotfiles/.hyper.js /Users/maejimayuto/.hyper.js

#######################################
# シンボリックリンクの削除
#######################################

# unlink ~/.gitattributes_global
# unlink ~/.gitconfig
# unlink ~/.gitignore_global
# unlink ~/.tmux.conf
# unlink ~/.zshrc
# unlink ~/.zsh_history
# unlink ~/Brewfile
# unlink ~/.hyper.js
