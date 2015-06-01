#! /bin/bash
EMAIL_USER=`echo 'uvtu.evire' | tr nopqrstuvwxyzabcdefghijklm abcdefghijklmnopqrstuvwxyz`
EMAIL_ATMARK='@'
EMAIL_DOMAIN=`echo 'tznvy.pbz' | tr nopqrstuvwxyzabcdefghijklm abcdefghijklmnopqrstuvwxyz`

cd ~/dotfiles
git config user.name 'Takaaki Kasai'
git config user.email "$EMAIL_USER$EMAIL_ATMARK$EMAIL_DOMAIN"

cd ~
git config --global diff.algorithm 'histogram'
git config --global alias.l 'log --graph --all --date=short --date-order --format="%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)"'
ln -snf ~/dotfiles/.zsh ~/.zsh
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -snf ~/dotfiles/.vim ~/.vim

if [ `uname` = 'Darwin' ]; then
  #mac用のコード
  git config --global core.editor 'env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim'
  git config --global diff.tool 'macvim'
  git config --global difftool.macvim.cmd 'env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/vimdiff $LOCAL $REMOTE'
  ln -sf ~/dotfiles/.zshrc.mac ~/.zshrc
elif [ `uname` = 'Linux' ]; then
  #Linux用のコード
  git config --global core.editor 'vim'
  git config --global diff.tool 'vimdiff'
  ln -sf ~/dotfiles/.zshrc.linux ~/.zshrc
fi
