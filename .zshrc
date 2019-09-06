# vim:set ts=4 sts=4 sw=4 ft=zsh:
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

typeset -U path PATH fpath # 重複を避けたい変数

### ヒストリ関連 ###################################################
setopt APPEND_HISTORY # ヒストリを使用する
setopt INC_APPEND_HISTORY # ヒストリをインクリメンタルに追加
setopt SHARE_HISTORY # zshプロセス間でヒストリを共有する
setopt hist_ignore_all_dups # 既にヒストリにあるコマンド行は古い方を削除
setopt hist_reduce_blanks # コマンドラインの余計なスペースを排除
setopt hist_no_store # historyコマンドは登録しない
setopt extended_history # コマンドの開始時刻と経過時間を登録

# ヒストリを保存する
HISTSIZE=1000000 # ヒストリを記憶する件数
HISTFILE=~/.zsh_history # ヒストリを保存するファイル
SAVEHIST=1000000 # ヒストリを保存する件数

bindkey '^P' history-beginning-search-backward # 先頭マッチのヒストリサーチ
bindkey '^N' history-beginning-search-forward # 先頭マッチのヒストリサーチ


### 色関係 ############################################################
autoload -U colors    # 機能の読み込み
colors                # 機能の実行

case "${OSTYPE}" in
    darwin*)
        # Mac
        export LSCOLORS=exfxcxdxbxegedabagacad
        export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        ;;
    linux*)
        # Linux
        if [ -x "$(which dircolors)" ] && [ -e $HOME/.dir_colors ]; then
            eval $(dircolors $HOME/.dir_colors)
        fi
        ;;
esac

# 補完リストをカラー化
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


### 補完関連 ############################################################
# 補完関数ファイルのパス指定
fpath=(~/.zsh $fpath)

autoload -U compinit    # 機能の読み込み
case "${OSTYPE}" in
    darwin*)
        # Mac
        compinit -u     # 機能の実行(権限チェックを省略)
        ;;
    linux*)
        # Linux
        compinit        # 機能の実行
        ;;
esac

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
# setopt mark_dirs

# グロッビングによるメタキャラクタを使用できる
setopt EXTENDED_GLOB

# 補完の時に小文字でも大文字にヒットする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完の表示を拡張する
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# 補完候補を拡張子で指定する
#compdef _tex platex             # platexの後に*.texを補完
#compdef _dvi dvipdfmx           # dvipdfmxの後に*.dviを補完

# 補完候補表示時に、日本語の濁点、半濁点を分けずに表示する
setopt combining_chars

# 定義したエイリアスでも補完を効かせる
_git-ddu () { _git-diff; }
_git-dds () { _git-diff; }
_git-dlu () { _git-diff; }
_git-dls () { _git-diff; }
_git-dtu () { _git-difftool; }
_git-dts () { _git-difftool; }
# _git-pushall () { _git-push; }
_git-pushmulti () { _git-push; }
_git-pushforcemulti () { _git-push; }
_git-pushdeletemulti () { _git-push; }
_git-fetchall () { _git-fetch; }
_git-mergetest () { _git-merge; }

### 動作挙動関連 ############################################################
# rm * を実行する前に確認される。
setopt rmstar_wait

# unsetopt promptcr               # 改行のない出力をプロンプトで上書きするのを防ぐ
setopt prompt_subst             # ESCエスケープを有効にする

# ^Dでログアウトしないようにする。
setopt ignore_eof

# バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

# exitでバックグラウンドジョブが終了しないようにする。
setopt nohup

# 8 ビット目を通すようになり、日本語のファイル名などを見れるようになる
setopt print_eightbit

# cdでpushdする。
setopt auto_pushd

# pushdで同じディレクトリを重複してpushしない。
setopt pushd_ignore_dups

# cd -[tab] でpushd
# これはauto_pushdと同じ意味
# setopt autopushd

# スクリプト実行中のキーバインド
stty    erase   '^H'
stty    intr    '^C'
stty    susp    '^Z'

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## never ever beep ever
setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0


### プロンプト関連 ############################################################
source ~/.zsh/git-prompt.sh
# setopt TRANSIENT_RPROMPT
unset RPROMPT

case $TERM in
    xterm*)
        BASE_PROMPT=$'%{\e]0;[%n@%m:%~]\a%}'$'[%n@%m%{\e[00m%}]%(5~,%-1~/.../%1~,%~)%# '
        ;;
    *)
        BASE_PROMPT=$'[%n@%m%{\e[00m%}]%(5~,%-2~/.../%2~,%~)%# '
        ;;
esac

# Enter を打った時に実行する関数
function my_accept_line() {
    # プロンプトにgit状態も表示されている場合、git状態の表示を消す
    if [[ ${#PROMPT} -ne ${#BASE_PROMPT} ]]; then
        # 先に消すとちらつくので、表示したい内容で上書きしてから余計な部分を消す
        print -n $'\e[s\e[F' # カーソル位置を保存し、前の行の先頭に移動
        print -Pn "$BASE_PROMPT" # BASE_PROMPTを表示
        print -Rn "$BUFFER" # 入力内容を再表示
        print -n $'\e[K\e[E\e[2K\e[u\e[A' # カーソルより後ろを消し、次の行に移動して行全体を消し、保存したカーソル位置に戻り、カーソル位置を1行上に移動
    fi
    zle accept-line
}
zle -N my_accept_line
bindkey '^M' my_accept_line

# プロンプト表示前に実行される関数
# (これを使用しなくてもpreexec()で変更したプロンプトは元に戻る)
precmd () {
    # RPROMPT=$(echo $(__git_ps1 "[%s]")|sed -e s/%/%%/|sed -e s/%%%/%%/|sed -e 's/\$/\\$/')
    local git_prompt="$(__git_ps1 '%s')"
    if [[ -n "$git_prompt" ]]; then
        # local color=36 # cyan
        local color=34 # blue
        if [[ $git_prompt == *'*'* ]]; then
            color=31 # red
        elif [[ $git_prompt == *'%'* ]]; then
            color=33 # yellow
        elif [[ $git_prompt == *'+'* ]]; then
            color=32 # green
        elif [[ $git_prompt == *'$'* ]]; then
            color=35 # magenta
        fi
        PROMPT=$'\e['"$color"$'m(\ue0a0 '"$git_prompt"$')\e[0m\n'"$BASE_PROMPT"
    else
        PROMPT="$BASE_PROMPT"
    fi
}
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=""
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWCOLORHINTS=0

# コマンド実行直前に実行される関数
# プログラム実行中にウィンドウタイトルを変更できる
preexec () {
    case $TERM in
        xterm*)
            [[ -t 1 ]] || return #標準出力が開いていなければ終了
            #print -Pn '%{\e]2;$2 - [%n@%m:%~]\a\e]1;$2 [@%m%#:%~]\a%}'
            print -Pn $'%{\e]0;$2 - [%n@%m:%~]\a%}'
            ;;
    esac
}

### メモリ制限
#ulimit -m 870068

### PATH ############################################################
# 個人用の PATH を追加
#export PATH="/sbin:$PATH"
#export PATH="/usr/sbin:$PATH"
#export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"


### set alias ############################################################
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias crontab="crontab -i"

case "${OSTYPE}" in
    darwin*)
        # Mac
        alias ls="ls -hFG"
        alias la="ls -hAFG"
        alias ll="ls -lhAFG"
        if [ -d /Applications/MacVim.app ]; then
            alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
            alias view='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -R "$@"'
            alias vimdiff='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -d "$@"'
        fi
        ;;
    linux*)
        # Linux
        alias ls="ls -hF --color=auto"
        alias la="ls -hAF --color=auto"
        alias ll="ls -lhAF --color=auto"
        ;;
esac

if [ -x "$(which colordiff)" ]; then
    alias diff="colordiff -u"
fi

alias tiga="tig --all"
alias tigs="tig status"
alias grep="grep --color=auto"

# alias as function
function gifo() { git-foresta --style=10 "$@" | less }
function gifa() { git-foresta --all --style=10 "$@" | less }
compdef _git gifo=git-log
compdef _git gifa=git-log

function agg() { ag "$@" $(git ls-files) }
function agl() { ag -l "$@" $(git ls-files) }
function agv() { vim -p $(ag -l "$@" $(git ls-files)) }

### 環境変数 ############################################################
#export JAVA_HOME=/usr/java/latest
#export XKEYSYMDB=/usr/share/X11/XKeysymDB
#export XAPPLRESDIR=/usr/share/X11
export SVN_EDITOR=vim
# export LESS='-g -i -j10 -R -Q'
export LESS='-i -R -S -Q'

### アプリケーション固有設定 ############################################################
# for rbenv
if [ -d /usr/local/rbenv ]; then
    export RBENV_ROOT="/usr/local/rbenv"
    export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init --no-rehash -)"
fi

# for plenv
if [ -d "$HOME/.plenv" ]; then
    export PATH="$HOME/.plenv/bin:$PATH"
    eval "$(plenv init -)"
fi

# for nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# for peco
PECO="$(which peco)"

# for tmux (.zshrc 全体の末尾に配置すること)
function starttmux() {
    if [[ -x "$(which tmux)" && -x "$PECO" ]]; then
        if [[ -z "$TMUX" && $- == *'l'* ]]; then
            # get the TMUX_IDs
            tmux_sessions="$(tmux list-sessions 2>/dev/null)"
            tmux_create_new_session='Create New Session'
            tmux_skip_tmux='Skip tmux'
            tmux_choices="$tmux_create_new_session\n$tmux_skip_tmux"
            if [[ -n $tmux_sessions ]]; then
                tmux_choices="$tmux_sessions\n$tmux_choices"
            fi
            TMUX_ID="$(echo $tmux_choices | $PECO | cut -d: -f1)"
            if [[ "$TMUX_ID" == "$tmux_create_new_session" ]]; then
                echo -n 'New session name: '
                read tmux_new_session_name
                exec tmux new-session -s "$tmux_new_session_name"
            elif [[ "$TMUX_ID" == "$tmux_skip_tmux" ]]; then
                :  # Start terminal normally
            elif [[ -n "$TMUX_ID" ]]; then
                {
                    sleep 0.01; tmux kill-session -C -t "$TMUX_ID" # アタッチ直後に全ウィンドウの通知をクリア
                    sleep 0.05; tmux kill-session -C -t "$TMUX_ID" # 少し遅れて通知してくるアプリケーション対策として再度クリア
                    sleep 0.1; tmux kill-session -C -t "$TMUX_ID"  # 念のためもう1度クリア
                } &
                exec tmux attach-session -d -t "$TMUX_ID"
            else
                :  # Start terminal normally
            fi
        fi
    else
        echo '============================'
        echo 'Please install tmux and peco'
        echo '============================'
    fi
}
function ssh() {
    if [[ -n "$TMUX" ]]; then
        local window_name="$(tmux display -p '#{window_name}')"
        tmux rename-window "$(echo "$*" | sed -re 's/^.*(@[^[:space:]]+).*$/\1/')"
        trap "tmux rename-window $window_name; tmux set-window-option automatic-rename "on" 1>/dev/null" INT EXIT ZERR
    fi
    command ssh $@
}
function exit() {
    if [[ -z "$TMUX" ]]; then
        builtin exit
    else
        tmux detach
    fi
}
function exit!() {
    builtin exit
}
if [[ $OSTYPE == 'linux'* ]]; then
    starttmux
fi
