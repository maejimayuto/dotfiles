export LANG=ja_JP.UTF-8

autoload -Uz colors
colors

bindkey -e

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

autoload -U promptinit; promptinit
prompt pure

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

fpath=(/usr/local/share/zsh-completions $fpath)

autoload -Uz compinit
compinit -u

# 補間で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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

setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_glob
setopt correct
setopt list_packed
setopt complete_aliases

# コマンドの途中でctrl-pでそのコマンドから始まる履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

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

alias chrome='open -n /Applications/Google\ Chrome.app'
alias safari='open -a Safari'
alias line='open -a LINE'
alias calc='open -a Calculator'
alias sys="open -a 'System Preferences'"
alias slack='open -a Slack'
alias skype='open -a Skype'
alias sour='open -a Sourcetree'
alias mv='mv -i'
alias cp='cp -i'
alias sz='source ~/.zshrc'
alias tree='tree -NCF'
alias mkdir='mkdir -p'
alias du='du -h'
alias df='df -h'
alias sudo='sudo '
alias grep='grep --color'
alias dcom='docker-compose'
alias dk='docker'
alias gcl="git fetch --prune; git br --merged master | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d % ; git br --merged develop | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d % ;git sync ; git br -vv"
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'
alias -g L='| less'
alias -g G='| grep'
alias -g AL='; say finish'

# Linux へのコピペ用
# alias ls='ls --color=auto -F'
# alias la='ls --color=auto -Fa'
# alias ll='ls --color=auto -Flh'
# alias lla='ls --color=auto -Falh'
# alias ..='cd ../'
# alias ...='cd ../../'
# alias ....='cd ../../../'
# alias .....='cd ../../../../'
# alias dcom='docker-compose'
# alias dk='docker'
# eval `ssh-agent`
# export LANGUAGE=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8

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

case ${OSTYPE} in
    darwin*)
        alias ls='gls --color=auto -F'
        alias la='gls --color=auto -Fa'
        alias ll='gls --color=auto -Flh'
        alias lla='gls --color=auto -Falh'
        ;;
    linux*)
        alias ls='ls --color=auto -F'
        alias la='ls --color=auto -Fa'
        alias ll='ls --color=auto -Flh'
        alias lla='ls --color=auto -Falh'
        ;;
esac

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

export PATH=/usr/bin:/bin:/usr/sbin:/sbin
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH

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
# export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`
# PATH=${JAVA_HOME}/bin:${PATH}
# https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/macos-install.html
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home

# Git
export PATH="/usr/local/Cellar/git/2.5.0/bin:$PATH"
# $ git diff
# diff-highlight | less: diff-highlight: command not found
# で怒られるので下記を実行する
# sudo ln -s /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/diff-highlight

# Laravel
export PATH="$HOME/.composer/vendor/bin:$PATH"

# MySQL
# export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"

# Androis Studio
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_HOME=$HOME/Library/Android/sdk
# avdmanager, sdkmanager
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
# adb, logcat
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
# emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools

export EDITOR="vim"

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"

# postgres
export PGDATA='/usr/local/var/postgres'

# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
export PATH="$HOME/.nodenv/shims:$PATH"

# npm
export PATH=$PATH:`npm bin -g`

# gcloud
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# flutter
export PATH="$PATH:$HOME/work/settings/flutter/bin"

# pip https://qiita.com/tom-u/items/134e2b8d4e11feea8e12
export PATH="$HOME/Library/Python/2.7/bin:$PATH"

# ntfy https://qiita.com/HikoMSP/items/8977c12e44dba78f4a39
# eval "$(ntfy shell-integration)"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# maven brew で入れ直した
# export PATH="$HOME/work/settings/maven/apache-maven-3.6.3/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/maejimayuto/work/settings/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/maejimayuto/work/settings/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/maejimayuto/work/settings/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/maejimayuto/work/settings/google-cloud-sdk/completion.zsh.inc'; fi

#jEnv
# https://qiita.com/uhooi/items/9a6747084bcfd4df07a6
export JENV_ROOT="$HOME/.jenv"
if [ -d "${JENV_ROOT}" ]; then
  export PATH="$JENV_ROOT/bin:$PATH"
  eval "$(jenv init -)"
fi
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# zinit light denysdovhan/spaceship-prompt