# Created by newuser for 5.3.1


# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

########################################
# 環境変数
export LANG=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%{$fg[blue]%}[%c]%{$reset_color%} %{$fg[yellow]%}$%{$reset_color%} "
RPROMPT="%*"

# 2行表示
# PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
# %# "

# set prompt
#
# case ${UID} in
# 0)
#   PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
#   PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
#   SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
#   [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
#     PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
#   ;;
# *)
#   PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
#   PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
#   SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
#   [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
#     PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
#   ;;
# esac

autoload -U promptinit; promptinit
prompt pure

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
#for zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)
# 補間
# 補間機能を有効にする
autoload -Uz compinit
compinit -u

# 補間で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 先方予測機能 慣れないため 中止
# autoload predict-on
# predict-on

# ../ の後は今いるディレクトリを補間しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補間する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補間
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# 補間候補一覧上で移動できるように
zstyle ':completion:*:default' menu select=1

# 補間候補にカレントディレクトリは含めない
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# 書式設定（何の？）
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

########################################
# vcs_info
# -- 右プロンプトにgitのブランチ情報を表示
# autoload -Uz vcs_info
# autoload -Uz add-zsh-hook

# zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
# zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

# function _update_vcs_info_msg() {
#     LANG=en_US.UTF-8 vcs_info
#     RPROMPT="${vcs_info_msg_0_}"
# }
# add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# コマンドの途中でctrl-pでそのコマンドから始まる履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# コマンド訂正
setopt correct

# 補間候補を詰めて表示
setopt list_packed

# aliasに登録されているコマンドの元のコマンドのオプションまで補間？
setopt complete_aliases

########################################

# https://gist.github.com/yonchu/3935922
# cdの後にlsを実行
chpwd() {
    ls_abbrev
}

ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('--color=always' '-aFlh')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-CFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 30 ]; then
        echo "$ls_result" | head -n 15
        echo '...'
        echo "$ls_result" | tail -n 15
        echo "$(command ls -1a | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}


# mkdirとcdを同時実行
function mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd $1
  else
    mkdir -p $1 && cd $1
  fi
}

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

# chrome起動
alias chrome='open -n /Applications/Google\ Chrome.app'
# safari起動
alias safari='open -a Safari'
# LINE起動
alias line='open -a LINE'
# メール起動
alias mail='open -a Mail'
# メモ帳起動
alias memo='open -a Notes'
# evernote起動
alias ever='open -a Evernote'
# 計算機起動
alias calc='open -a Calculator'
# システム環境設定起動
alias sys="open -a 'System Preferences'"
# slack起動
alias slack='open -a Slack'
# skype起動
alias skype='open -a Skype'
# Teams起動
alias teams='open -a Microsoft\ Teams'
# emacs起動
alias em='emacs'
# cetree起動
alias sour='open -a Sourcetree'
# mvに確認オプションの必須化
alias mv='mv -i'
# rmをゴミ箱を経由するコマンドに変更
alias rm='rmtrash'
# cpに確認オプションの必須化
alias cp='cp -i'
# .zshrcを読み込む
alias sz='source ~/.zshrc'
# treeに文字化けしないように、カラフルに、ファイルタイプ表示
alias tree='tree -NCF'
# wri.peへのアクセス
alias wri='open https://wri.pe/app'
# サブディレクトリも作成可能
alias mkdir='mkdir -p'
# 人間が読みやすい数値表記に
alias du='du -h'
alias df='df -h'
# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
alias grep='grep --color'
alias dcom='docker-compose'
alias dk='docker'
# 上のディレクトリへの移動を楽に
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'
# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# GitHub command https://github.com/github/hub
function git(){hub "$@"} # zsh

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi



########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        # lsをカラフルに、ファイルタイプ表示
        alias ls='gls --color=auto -F'
        # lsをカラフルに、ファイルタイプ表示、不可視ファイル、ディレクトリも表示
        alias la='gls --color=auto -Fa'
        # lsをカラフルに、ファイルタイプ表示、単位を読みやすく、
        alias ll='gls --color=auto -Flh'
        # lsをカラフルに、ファイルタイプ表示、単位を読みやすく、不可視ファイル、ディレクトリも表示
        alias lla='gls --color=auto -Falh'
        ;;
    linux*)
        #Linux用の設定
        # lsをカラフルに、ファイルタイプ表示
        alias ls='ls --color=auto -F'
        # lsをカラフルに、ファイルタイプ表示、不可視ファイル、ディレクトリも表示
        alias la='ls --color=auto -Fa'
        # lsをカラフルに、ファイルタイプ表示、単位を読みやすく、
        alias ll='ls --color=auto -Flh'
        # lsをカラフルに、ファイルタイプ表示、単位を読みやすく、不可視ファイル、ディレクトリも表示
        alias lla='ls --color=auto -Falh'
        ;;
esac

# vim:set ft=zsh:

########################################
# 前島追加分

# PATHの追加
# path=(/usr/local/bin(N-/) $path)
# おそらくdefaultのPATH
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
# 追加したPATH
export PATH=/usr/local/bin:$PATH
# nodebrew導入時（20170321）PATHを通す
export PATH=$HOME/.nodebrew/current/bin:$PATH
# 遊び 自作コマンド用
# export PATH=$PATH:$HOME/work/bin

# treeコマンドなどのGNU系のコマンドの色づきを指定
if [ -f ~/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors ~/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors ~/.dircolors)
    fi
fi

# 補間候補もlsと同じようにカラフルに
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="/Users/maejimayuto-Mac/.sdkman"
# [[ -s "/Users/maejimayuto-Mac/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/maejimayuto-Mac/.sdkman/bin/sdkman-init.sh"

# Setting for rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Setting for golang
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Setting for hyperledger-fabric
export PATH=~/work/projects/archi_team/fabric-samples/bin:$PATH

# Java
export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`
PATH=${JAVA_HOME}/bin:${PATH}

# Git
export PATH="/usr/local/Cellar/git/2.5.0/bin:$PATH"

# Laravel
export PATH="$HOME/.composer/vendor/bin:$PATH"

# MySQL
# export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"

# Androis Studio
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/Library/Android/sdk/tools:$PATH

export EDITOR="vim"

# github command
function git(){hub "$@"}
