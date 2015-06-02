" カラー設定
colorscheme solarized
" ビープ音抑制
set visualbell t_vb=
" コマンドラインの高さ(GUI用に.vimrcではなく.gvimrcで設定が必要)
set cmdheight=1
" 改行文字とタブ文字を表示
set listchars=tab:￫\ ,trail:⋅                    " 特殊文字の代替文字(タブと行末のスペース) U+ffeb U+22C5
" 改行文字とタブ文字の色設定（NonTextが改行、SpecialKeyがタブ）
highlight SpecialKey gui=none guifg=#657b83 guibg=NONE
highlight Nontext gui=none guifg=#657b83 guibg=NONE
" ZenkakuSpace の定義は .vimrc 参照
highlight ZenkakuSpace gui=underline guifg=#93a1a1 guibg=NONE
set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h14
