# vim:set ts=4 sts=4 sw=4 ft=zsh:
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#


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
        if [ -x `which dircolors` ] && [ -e $HOME/.dir_colors ]; then
            eval `dircolors $HOME/.dir_colors`
        fi
        ;;
esac

# 補完リストをカラー化
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


### 補完関連 ############################################################
# 補完関数ファイルのパス指定
fpath=(~/.zsh $fpath)

autoload -U compinit    # 機能の読み込み
compinit                # 機能の実行

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
# PS1=$'%{\e]2;[%n@%m:%~]\a'$'\e]1;@%m%#:%~\a%}'$'[%n@%m%{\e[00m%}]%~%# '
if [ "$PS1" ]; then
    case $TERM in
        xterm*)
            #PS1=$'%{\e]2;[%n@%m:%~]\a'$'\e]1;@%m%#:%~\a%}'$'[%n@%m%{\e[00m%}]%(5~,%-1~/.../%1~,%~)%# '
            PS1=$'%{\e]0;[%n@%m:%~]\a%}'$'[%n@%m%{\e[00m%}]%(5~,%-1~/.../%1~,%~)%# '
            ;;
        *)
            PS1=$'[%n@%m%{\e[00m%}]%(5~,%-2~/.../%2~,%~)%# '
            ;;
    esac
fi

# プロンプト表示前に実行される関数
# (これを使用しなくてもpreexec()で変更したプロンプトは元に戻る)
source ~/.zsh/git-prompt.sh
setopt TRANSIENT_RPROMPT
precmd () {
    RPROMPT=`echo $(__git_ps1 "[%s]")|sed -e s/%/%%/|sed -e s/%%%/%%/|sed -e 's/\\$/\\\\$/'`
}
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
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
            alias vimdiff='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/vimdiff "$@"'
        fi
        ;;
    linux*)
        # Linux
        alias ls="ls -hF --color=auto"
        alias la="ls -hAF --color=auto"
        alias ll="ls -lhAF --color=auto"
        if [ -x `which colordiff` ]; then
            alias diff=colordiff
        fi
        ;;
esac

alias tiga="tig --all"
alias tigs="tig status"
alias grep="grep --color=auto"
alias git-forest="git-forest --all | less"

### 環境変数 ############################################################
#export JAVA_HOME=/usr/java/latest
#export XKEYSYMDB=/usr/share/X11/XKeysymDB
#export XAPPLRESDIR=/usr/share/X11
export SVN_EDITOR=vim
# export LESS='-g -i -j10 -R -Q'
export LESS='-i -R -Q'

### アプリケーション固有設定 ############################################################
# for rbenv
if [ -d /usr/local/rbenv ]; then
    export RBENV_ROOT="/usr/local/rbenv"
    export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init --no-rehash -)"
fi

# for nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
