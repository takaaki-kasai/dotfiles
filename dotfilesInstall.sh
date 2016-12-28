#! /bin/bash
EMAIL_USER=`echo 'uvtu.evire' | tr nopqrstuvwxyzabcdefghijklm abcdefghijklmnopqrstuvwxyz`
EMAIL_ATMARK='@'
EMAIL_DOMAIN=`echo 'tznvy.pbz' | tr nopqrstuvwxyzabcdefghijklm abcdefghijklmnopqrstuvwxyz`

cd ~/dotfiles
git config user.name 'Takaaki Kasai'
git config user.email "$EMAIL_USER$EMAIL_ATMARK$EMAIL_DOMAIN"

cd ~
git_user_name=$(git config --global user.name)
git_user_email=$(git config --global user.email)
rm -f ~/.gitconfig
git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"
git config --global diff.algorithm 'histogram'
git config --global diff.indentHeuristic true
git config --global core.whitespace trailing-space,tab-in-indent
git config --global push.default nothing
git config --global alias.ddu 'diff -M100%'
git config --global alias.dds 'diff -M100% --cached'
git config --global alias.dlu 'diff -M100% --name-status'
git config --global alias.dls 'diff -M100% --name-status --cached'
git config --global alias.dtu 'difftool -M100%'
git config --global alias.dts 'difftool -M100% --cached'
git config --global alias.l 'log --graph --all --date=short --date-order --format="%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)"'
git config --global alias.lb 'log --graph --date=short --date-order --format="%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)"'
git config --global alias.s 'status'
git config --global alias.pushall '!f(){ for i in `git remote`; do git push $i $1; done; };f'
git config --global alias.fetchall '!f(){ for i in `git remote`; do git fetch --prune $i; done; };f'
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -snf ~/dotfiles/.zsh ~/.zsh
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -snf ~/dotfiles/.vim ~/.vim
ln -sf ~/dotfiles/.dir_colors ~/.dir_colors
ln -sf ~/dotfiles/.colordiffrc ~/.colordiffrc
ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.tigrc ~/.tigrc
ln -sf ~/dotfiles/.tigrc.vim ~/.tigrc.vim
mkdir -p ~/bin
ln -sf ~/dotfiles/bin/git-diff-normal-format ~/bin/git-diff-normal-format
ln -sf ~/dotfiles/bin/rubocop ~/bin/rubocop

if [ `uname` = 'Darwin' ]; then
  # Mac用のコード
  git config --global core.editor 'env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim'
  git config --global diff.tool 'macvim'
  git config --global difftool.macvim.cmd 'env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/vimdiff $LOCAL $REMOTE'
  ln -sf ~/dotfiles/.karabiner/private.xml ~/Library/Application\ Support/Karabiner/private.xml
elif [ `uname` = 'Linux' ]; then
  # Linux用のコード
  git config --global core.editor 'vim'
  git config --global diff.tool 'vimdiff'
fi
