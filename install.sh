#!/bin/bash

set -u
DOT_DIRECTORY="${HOME}/dotfiles"

for f in .??*
do
    #無視したいファイルやディレクトリ
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done

echo "link .config directory dotfiles"
cd ${DOT_DIRECTORY}/${DOT_CONFIG_DIRECTORY}
for file in `\find . -maxdepth 8 -type f`; do
#./の2文字を削除するためにfile:2としている
    ln -snfv ${DOT_DIRECTORY}/${DOT_CONFIG_DIRECTORY}/${file:2} ${HOME}/${DOT_CONFIG_DIRECTORY}/${file:2}
done

echo "linked dotfiles complete!"

#
# ln -snfv /Users/yuto.maejima/dotfiles/.gitattributes_global /Users/yuto.maejima/.gitattributes_global
# ln -snfv /Users/yuto.maejima/dotfiles/.gitconfig /Users/yuto.maejima/.gitconfig
# ln -snfv /Users/yuto.maejima/dotfiles/.gitignore_global /Users/yuto.maejima/.gitignore_global
# ln -snfv /Users/yuto.maejima/dotfiles/.tmux.conf /Users/yuto.maejima/.tmux.conf
# ln -snfv /Users/yuto.maejima/dotfiles/.zshrc /Users/yuto.maejima/.zshrc
#
# unlink .gitattributes_global
# unlink .gitconfig
# unlink .gitignore_global
# unlink .tmux.conf
# unlink .zshrc
