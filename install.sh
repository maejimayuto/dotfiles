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

# ln -snfv ~/work/settings/dotfiles/.gitattributes_global ~/.gitattributes_global
# ln -snfv ~/work/settings/dotfiles/.gitconfig ~/.gitconfig
# ln -snfv ~/work/settings/dotfiles/.gitignore_global ~/.gitignore_global
# ln -snfv ~/work/settings/dotfiles/.stCommitMsg ~/.stCommitMsg
# ln -snfv ~/work/settings/dotfiles/.tmux.conf ~/.tmux.conf
# ln -snfv ~/work/settings/dotfiles/.zprofile ~/.zprofile
# ln -snfv ~/work/settings/dotfiles/.zshrc ~/.zshrc
# ln -snfv ~/work/settings/dotfiles/.tigrc ~/.tigrc
# ln -snfv ~/work/settings/dotfiles/.Brewfile ~/Brewfile
# ln -snfv ~/work/settings/dotfiles/ssh_config ~/.ssh/config

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
# unlink ~/.ssh/config
