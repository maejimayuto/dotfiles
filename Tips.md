# Tips for zsh

---

## 発表の目的
皆さんのコンソールライフがもっと快適になることを祈って

---

## lang
write in ~/.zshrc

```bash:~/.zshrc
export LANG=ja_JP.UTF-8
```

### description
黙って日本語にしておけ

---

## zsh-completions
### how to install
```bash
$ brew install zsh-completions
```

write in ~/.zshrc

```bash:~/.zshrc
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
compinit -u
```

### description
`git` などの後の tab を押すと候補が表示されるようになる
もはや無意識で使いすぎていて、これがあると、どう嬉しいなどの説明はできない

---

## completion option

write in ~/.zshrc

```bash:~/.zshrc
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # 補完候補で、大文字・小文字を区別しないで補完出来るようにするが、大文字を入力した場合は区別する
zstyle ':completion:*' ignore-parents parent pwd ..    # ../ の後は今いるディレクトリを補間しない
zstyle ':completion:*:default' menu select=1           # 補間候補一覧上で移動できるように
zstyle ':completion:*:cd:*' ignore-parents parent pwd  # 補間候補にカレントディレクトリは含めない
```

### description
補完をもっと強化する

---

## history

write in ~/.zshrc

```bash:~/.zshrc
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt share_history           # 履歴を他のシェルとリアルタイム共有する
setopt hist_ignore_all_dups    # 同じコマンドをhistoryに残さない
setopt hist_ignore_space       # historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks      # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups       # 重複するコマンドが保存されるとき、古い方を削除する
setopt inc_append_history      # 実行時に履歴をファイルにに追加していく
```

---

## keybind


write in ~/.zshrc

```bash:~/.zshrc
bindkey -e
```

### description
Mac はデフォルトで emacs なので設定いらんかもだけど
↑ ctr+p, ↓ ctr+n, → ctr+f, ← ctr+b
先頭 ctr+a、最後尾 ctr+e、前を削除 ctr+h、後ろを削除 ctr+d

---

## search history

ctr+r で検索

write in ~/.zshrc

```bash:~/.zshrc
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
```

### description
先頭が一致したコマンドの履歴を一つづつたどれる
`git`, `docker` など先頭が同じコマンド群でよく使う

---

## alias

write in ~/.zshrc

```bash:~/.zshrc
alias ls='ls -F'
alias la='ls -Fa'
alias ll='ls -Flh'
alias lla='ls -Falh'
alias ..='cd ../'
alias ...='cd ../../'
alias dcom='docker-compose'
alias dk='docker'
```

---

## もし興味があれば
マージされたローカルブランチが全て削除される

write in ~/.zshrc

```bash:~/.zshrc
alias gcl="git fetch --prune; git br --merged master | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d % ; git br --merged main | grep -vE '^\*|main$|develop$' | xargs -I % git branch -d % ; git br --merged develop | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d %; git br -vv"
```

---

## chpwd

write in ~/.zshrc

```bash:~/.zshrc
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
```



---

## prompt

色々使ったけど
pure がおすすめ
https://github.com/sindresorhus/pure

powerlevel とかはかっこいいが、レンダリングが遅かったので、やめた（3年ぐらい前なので、改善されているかも）
https://github.com/romkatv/powerlevel10k

---

## git
多分、タイムアウトなので、記載だけ

write in ~/.gitconfig

```bash:~/.gitconfig
[alias]
  a   = add
  aa  = add -A
  ap  = add -p
  ai  = add -i
  br  = branch
  brv = branch -vv
  co  = checkout
  cod = !git checkout develop && git pull
  cl  = clean
  cm  = commit
  d   = diff
  ds  = diff --staged
  dif = diff --word-diff --ignore-space-change --ignore-blank-lines
  p   = pull
  lo  = log --oneline --graph --decorate --date="iso" --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
  lop = log -p --oneline --graph --decorate --date="iso" --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
  logp= log -p
  mgd = !git fetch && git merge origin/develop
  rs  = restore
  rmv = remote -v
  s   = status --short --branch
  st  = status
  ss  = stash
  sw  = switch
  swd = !git switch develop && git pull
```