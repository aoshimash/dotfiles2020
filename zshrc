HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
autoload -U colors && colors
autoload -U vcs_info

source <(kubectl completion zsh)
source <(kubesec completion zsh)
source <(helm completion zsh)
source <(kompose completion zsh)

# Emacsモード（カーソル移動くらい？）
bindkey -e

# バックグラウンド処理の状態変化をすぐに通知する
setopt notify
# ワイルドカードが強力になるらしい
setopt extendedglob
# コマンドのスペルチェック
setopt correct
# Historyに時刻情報をつける
setopt extended_history
# historyコマンドをHistoryにいれない
setopt HIST_NO_STORE
# 複数プロセスで履歴を共有
setopt SHARE_HISTORY
# Ctrl-D でログアウトするのを防ぐ
setopt ignore_eof

# alias設定
#alias ls='ls --color' # for Linux
alias ls='ls -G'  # for Mac
#alias diff='diff --color=auto'  # for Linux only
alias grep='grep --color=auto'
#alias elm-test='${HOME}/.nvm/versions/node/v10.1.0/lib/node_modules/elm-test/bin/elm-test'
alias k='kubectl'
alias kns='kubens'
alias kctx='kubectx'
alias ksec='kubesec'
alias wk='watch kubectl'

# nvm 設定  for Arch Linux
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#source /usr/share/nvm/init-nvm.sh

# zplug設定
source ${HOME}/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "rupa/z", use:"*.sh"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

# インストールの必要があるときはインストールをする
if ! zplug check; then
  zplug Install
fi

# プラグインを読み込み、コマンドを実行可能にする
zplug load


function select-history()
{
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}

zle -N select-history
bindkey '^r' select-history

function _ssh {
  compadd `fgrep 'Host ' ~/.ssh/config | awk '{print $2}' | sort`;
}

# SPACESHIPのOption
SPACESHIP_CHAR_SUFFIX=' '

PATH="$KREW_PATH:$HOME_BIN:$MYSQL_CLIENT_BIN:$ISTIO_BIN:$PYENV_BIN:$PATH"
