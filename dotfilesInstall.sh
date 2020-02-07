#! /bin/bash
EMAIL_USER=$(echo 'uvtu.evire' | tr nopqrstuvwxyzabcdefghijklm abcdefghijklmnopqrstuvwxyz)
EMAIL_ATMARK='@'
EMAIL_DOMAIN=$(echo 'tznvy.pbz' | tr nopqrstuvwxyzabcdefghijklm abcdefghijklmnopqrstuvwxyz)

cd ~/dotfiles
git config user.name 'Takaaki Kasai'
git config user.email "$EMAIL_USER$EMAIL_ATMARK$EMAIL_DOMAIN"

cd ~
git_user_name=$(git config --global user.name)
git_user_email=$(git config --global user.email)
rm -f ~/.gitconfig
git config --global init.templatedir '~/.git_templates'
git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"
git config --global diff.algorithm 'histogram'
# git config --global diff.indentHeuristic true
# git config --global core.abbrev 8
git config --global core.whitespace trailing-space,tab-in-indent
git config --global push.default nothing
git config --global alias.ddu 'diff -M100% -C100%'
git config --global alias.dds 'diff -M100% -C100% --cached'
git config --global alias.dlu 'diff -M100% -C100% --name-status'
git config --global alias.dls 'diff -M100% -C100% --name-status --cached'
git config --global alias.dtu 'difftool -M100% -C100%'
git config --global alias.dts 'difftool -M100% -C100% --cached'
git config --global alias.l 'log --graph --all --date=short --date-order --format="%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)"'
git config --global alias.lb 'log --graph --date=short --date-order --format="%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)"'
git config --global alias.s 'status'
# git config --global alias.pushall '!f(){ for i in $(git remote); do git push $i $1; done; };f'
git config --global alias.pushmulti '!f(){ for i in $(echo "$1" | tr "," " "); do echo "--- Pushing $2 to $i"; git push $i $2; echo ""; done; };f'
git config --global alias.pushforcemulti '!f(){ for i in $(echo "$1" | tr "," " "); do echo "--- Force Pushing $2 to $i"; git push -f $i $2; echo ""; done; };f'
git config --global alias.pushdeletemulti '!f(){ for i in $(echo "$1" | tr "," " "); do echo "--- Deleting $2 from $i"; git push $i :$2; echo ""; done; };f'
git config --global alias.fetchall '!f(){ for i in $(git remote); do echo "--- Fetching from $i"; git fetch --prune $i; echo ""; done; };f'
git config --global alias.mergetest '!f(){ git merge $1 --no-commit --no-ff; local ret=$?; [ -f $(git rev-parse --git-dir)/MERGE_HEAD ] && git merge --abort && /bin/echo "Merge aborted"; if [ $ret -eq 0 ]; then /bin/echo -e "\e[32mMerge test: OK\e[m"; else /bin/echo -e "\e[31mMerge test: FAILED\e[m"; fi; }; f'
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -snf ~/dotfiles/.zsh ~/.zsh
ln -snf ~/dotfiles/.git_templates ~/.git_templates
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -snf ~/dotfiles/.vim ~/.vim
ln -sf ~/dotfiles/.dir_colors ~/.dir_colors
ln -sf ~/dotfiles/.colordiffrc ~/.colordiffrc
ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.tigrc ~/.tigrc
ln -sf ~/dotfiles/.tigrc.vim ~/.tigrc.vim
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.lesskey ~/.lesskey
[ -x "$(which lesskey)" ] && lesskey
mkdir -p ~/.config
ln -snf ~/dotfiles/.config/peco ~/.config/peco
mkdir -p ~/bin
ln -sf ~/dotfiles/bin/git-diff-normal-format ~/bin/git-diff-normal-format
ln -sf ~/dotfiles/bin/git-foresta ~/bin/git-foresta
ln -sf ~/dotfiles/bin/rubocop ~/bin/rubocop
ln -sf ~/dotfiles/bin/noah-firm-cp ~/bin/noah-firm-cp
ln -sf ~/dotfiles/bin/noah-firm-up ~/bin/noah-firm-up
ln -sf ~/dotfiles/bin/tmux-history-bytes ~/bin/tmux-history-bytes

if [ $(uname) = 'Darwin' ]; then
  # Mac用のコード
  git config --global core.editor 'env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim'
  git config --global diff.tool 'macvim'
  git config --global difftool.macvim.cmd 'env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -d $LOCAL $REMOTE'
  mkdir -p ~/.config/karabiner/assets/complex_modifications
  for rule in $(ls ~/dotfiles/.config/karabiner/assets/complex_modifications); do
    cp ~/dotfiles/.config/karabiner/assets/complex_modifications/$rule ~/.config/karabiner/assets/complex_modifications/$rule
  done
  ln -snf ~/dotfiles/.hammerspoon ~/.hammerspoon
elif [ $(uname) = 'Linux' ]; then
  # Linux用のコード
  git config --global core.editor 'vim'
  git config --global diff.tool 'vimdiff'
fi

if [ -x "$(which git)" ] && [ ! -e ~/.vim/bundle/repos/github.com/Shougo/dein.vim ]; then
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/dein_installer.sh
  sh /tmp/dein_installer.sh ~/.vim/bundle
  rm -f /tmp/dein_installer.sh
fi
