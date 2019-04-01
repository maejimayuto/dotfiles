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

# ln -snfv ~/work/settings/dotfiles/.gitattributes_global /Users/yuto.maejima/.gitattributes_global
# ln -snfv ~/work/settings/dotfiles/.gitconfig /Users/yuto.maejima/.gitconfig
# ln -snfv ~/work/settings/dotfiles/.gitignore_global /Users/yuto.maejima/.gitignore_global
# ln -snfv ~/work/settings/dotfiles/.tmux.conf /Users/yuto.maejima/.tmux.conf
# ln -snfv ~/work/settings/dotfiles/.zshrc /Users/yuto.maejima/.zshrc

#######################################
# シンボリックリンクの削除
#######################################

# unlink ~/.gitattributes_global
# unlink ~/.gitconfig
# unlink ~/.gitignore_global
# unlink ~/.tmux.conf
# unlink ~/.zshrc
