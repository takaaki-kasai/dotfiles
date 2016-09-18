" vim設定ファイル
" vim:set ts=2 sw=2 sts=0:

" 基礎設定 ------------------------------------------------------------
" <Leader>として割り当てるキーの変更
let mapleader = ','
" ,のデフォルトの機能は、\で使えるように退避
noremap \ ,

" 検索系 ------------------------------------------------------------
" 大文字小文字の区別に関する設定は、eregex導入にともない無効化
set ignorecase      " 大文字小文字を区別しない
set smartcase       " 大文字小文字両方含まれている場合は区別
" set incsearch     " 検索文字列入力時に随時検索する
set wrapscan        " 最後までいったら最初に戻る
set hlsearch        " 検索文字をハイライト
" ハイライトを消す
nnoremap <silent> <Leader>q :nohlsearch<CR>

" インデント系 ------------------------------------------------------
set expandtab                 " タブを挿入時にスペースに変換
set shiftwidth=2              " インデント時のシフト量
set tabstop=2                 " タブの表示幅
set autoindent                " 自動的にインデントする
set smartindent               " 高度なインデント機能を有効にする
filetype on                   " ファイルタイプ認識
filetype plugin on            " プラグインを有効に
filetype indent on            " インデント機能をオン

" 表示系 ------------------------------------------------------------
syntax on                                        " 色分けを有効に
set listchars=tab:￫\ ,trail:⋅                    " 特殊文字の代替文字(タブと行末のスペース) U+ffeb U+22C5
set guioptions-=T                                " ツールバーを非表示
set cmdheight=1                                  " コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set number                                       " 行番号を表示
set list                                         " 特殊文字を表示
set nowrap                                       " 画面端での自動折り返しを行わない
set display+=lastline                            " 画面最後の行をできる限り表示する。
" autocmd FileType * setlocal formatoptions+=B   " テキスト自動整形の振る舞い（参照：help fo-table）
set tabpagemax=20                                " タブページの最大個数

" 幅が曖昧な文字を一文字分(single)とするか二文字分(double)とするか
if exists('&ambiwidth')
  set ambiwidth=single
endif
" 折り畳みの方法をマーカーにする
set foldmethod=marker
" 常にタブで開く
"cab      e  tabe
" 括弧入力時の対応する括弧を表示
set showmatch
" 補完候補を表示する。
set wildmenu
set wildmode=longest,list
" 長い行を自動改行しない
set textwidth=0
" 長い行を自動改行しない : デフォルトvimrc_exampleのtextwidth設定上書き
autocmd FileType text setlocal textwidth=0


" システム系 ------------------------------------------------------------
" set backup                     " バックアップファイル(~ファイル)を作成する
set nobackup                     " バックアップファイル(~ファイル)を作成しない
set writebackup                  " ファイルの上書きの前にバックアップを作る。オプション 'backup' がオンでない限り、バックアップは上書きに成功した後削除される。
" set nowritebackup              " ファイルの上書きの前にバックアップを作らない
" set backupdir=~/.vimbackup/    " バックアップ格納フォルダ
" set patchmode=.orig            " オリジナルファイル拡張子
set noundofile                   " アンドゥファイル(~un)を作らない。※アンドゥファイルは、セッションを越えてアンドゥできるようにするためのもの。
set showcmd                      " 入力中のコマンドをステータスに表示する
set modelines=5                  " モードラインを認識可能な先頭・末尾の行数範囲
set laststatus=2                 " ステータスラインを常に表示
set wildignorecase               " ファイル名の補完時に大文字小文字を区別しない
" set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%l/%L,%c-%v)%8P     " ステータスラインに文字コードと改行文字を表示する

autocmd FileType * setlocal iskeyword+=-       " 単語の一部として認識させたい文字を追加

" マウス関連
set mouse=a            " マウス操作を有効にする
" スクロールを若干スムーズに
nnoremap <ScrollWheelUp> <C-Y><C-Y><C-Y>
" スクロールを若干スムーズに
nnoremap <ScrollWheelDown> <C-E><C-E><C-E>

" 挿入モードのIME状態デフォルトをC-jで切り替え
if has('win32') || has('win64')
  "挿入モード終了時にIME状態を保存しない
  inoremap <silent> <ESC> <ESC>
  inoremap <silent> <C-[> <ESC>
  "IMEモード固定
  inoremap <silent> <C-j> <C-^>
endif

" コマンドラインで履歴を前方一致検索する
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>

set backspace=indent,eol,start    " バックスペースでオートインデント、改行、挿入モード開始位置以前を削除できるようにする

" 挿入モードでカーソル形状を変更する
let &t_SI.="\e[6 q"
let &t_EI.="\e[2 q"
" カーソル形状がすぐに元に戻らないのでタイムアウト時間を調整
set ttimeoutlen=10
" 挿入モードを抜けた時にカーソルが見えなくなる現象対策(なぜかこれで治る)
inoremap <ESC> <ESC>

" 自動インデントさせずに貼り付けるための挿入モード
nnoremap <Space>i :<C-u>set paste<Return>i
nnoremap <Space>I :<C-u>set paste<Return>I
nnoremap <Space>a :<C-u>set paste<Return>a
nnoremap <Space>A :<C-u>set paste<Return>A
nnoremap <Space>o :<C-u>set paste<Return>o
nnoremap <Space>O :<C-u>set paste<Return>O
autocmd InsertLeave * set nopaste

" ビジュアルモード時、$が改行記号ではなくその前の行末の文字を指すようにする
vnoremap $ $h

" 折り返しの切り替え
if !&diff
  noremap <silent> <Leader>w :call MyToggleWrap()<CR>
end
function! MyToggleWrap()
  if &wrap
    echo 'Wrap OFF'
    setlocal nowrap nolinebreak list
    " setlocal virtualedit=all
    " setlocal display-=lastline
    silent! unmap  <buffer> k
    silent! unmap  <buffer> j
    silent! unmap  <buffer> 0
    silent! unmap  <buffer> $
    silent! unmap  <buffer> <Up>
    silent! unmap  <buffer> <Down>
    silent! unmap  <buffer> <Home>
    silent! unmap  <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo 'Wrap ON'
    setlocal wrap linebreak nolist
    " setlocal virtualedit=
    " setlocal display+=lastline
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
    vnoremap <buffer> <silent> $ g$h
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" gfする時タブでファイルを開く
nnoremap gf <C-W>gf
" 行連結後にスペースを削除
" nnoremap J J<C-[>x

" ウィンドウを均等に分割
nnoremap <C-W><Space> <C-W>=

" 常にタブでファイルを開く
" cab e tabe
" バッファ切り替え時に自動的にカレントディレクトリをファイルのある場所にする
" set autochdir
" ビープ音すべてを無効にする
set visualbell t_vb=

" diffの時にホワイトスペースを無視するかどうか
" diffchar.vim 利用時 diffopt の iwhite がオンだと単語単位の差分表示がずれるので独自定義
let g:my_diff_ignore_whitespace = 0

" diffのコマンド
set diffexpr=MyDiff()
function! MyDiff()
  let l:opt = ''
  if g:my_diff_ignore_whitespace
    let l:opt = l:opt . '-w '
  endif
  silent execute '!git-diff-normal-format ' . l:opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
  redraw!
endfunction

" diffの時にホワイトスペースを無視するかどうか切り替える関数
function! MyToggleDiffIgnoreWhiteSpace()
  if g:my_diff_ignore_whitespace
    let g:my_diff_ignore_whitespace = 0
    let l:msg = 'Not Ignore Whitespace'
  else
    let g:my_diff_ignore_whitespace = 1
    let l:msg = 'Ignore Whitespace'
  endif

  diffupdate
  call feedkeys("\<Plug>ToggleDiffCharAllLines\<Plug>ToggleDiffCharAllLines")  " 画面表示更新のため2回
  call feedkeys(":echo '" . l:msg . "'\<CR>")
endfunction

" vimdiffで起動した際の設定
if &diff
  " 自動的に単語単位のdiff(diffchar.vim)を有効にする -> Ver5.5でg:DiffModeSyncが導入されて不要に
  " augroup enable_diffchar
  "   autocmd!
  "   autocmd VimEnter * execute '%SDChar'
  " augroup END
  " ホワイトスペースを無視するかどうか切り替える
  noremap <silent> <Leader>w :call MyToggleDiffIgnoreWhiteSpace()<CR>
endif

" QuickFix の各ファイルに対して何かを実行するコマンド
command! -nargs=+ QFDo call MyQFDo(<q-args>)
function! MyQFDo(command)
  " Create a dictionary so that we can get the list of buffers
  " rather than the list of lines in buffers (easy way to get unique entries)
  let l:buffer_numbers = {}
  " For each entry, use the buffer number as a dictionary key (won't get repeats)
  for l:fixlist_entry in getqflist()
    let l:buffer_numbers[l:fixlist_entry['bufnr']] = 1
  endfor
  " Make it into a list as it seems cleaner
  let l:buffer_number_list = keys(l:buffer_numbers)
  " In new tab
  execute 'tabedit'
  " For each buffer
  for l:num in l:buffer_number_list
    " Select the buffer
    execute 'buffer' l:num
    " Run the command that's passed as an argument
    execute a:command
    " Save if necessary
    update
  endfor
endfunction

" クリップボード関連 -----------------------------------------------------
" クリップボードには2種類のレジスタがあり、他のアプリでは次の操作となる。
" *レジスタはセレクションでコピー/ミドルクリックで貼り付け
" +レジスタは右クリックメニューまたはCtrl-X,C,Vより操作
set clipboard+=unnamed        " ヤンク、カットの操作で無名レジスタではなくクリップボード(*レジスタ)を使う
" 選択部分をクリップボード(+レジスタ)にコピー
" vmap <C-C> "+y
" 挿入モード時、クリップボード(+レジスタ)から貼り付け
" imap <C-V> <ESC>"+pa
" 選択部分をクリップボード(+レジスタ)の値に置き換え
" vmap <C-V> d"+P
" コマンドライン時、クリップボード(+レジスタ)から貼り付け
" cmap <C-V> <C-R>+
" 選択部分をクリップボード(+レジスタ)に切り取り
" vmap <C-X> "+d<ESC>

" エンコーディング系 ----------------------------------------------------------
set encoding=utf-8                " デフォルトのエンコーディング

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! MyAUReCheckFENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call MyAUReCheckFENC()
endif
" utf-8優先
let &fileencodings = substitute(&fileencodings, 'utf-8', '_utf-8', 'g')
let &fileencodings = substitute(&fileencodings, 'cp932', 'utf-8', 'g')
let &fileencodings = substitute(&fileencodings, '_utf-8', 'cp932', 'g')
" 改行コードの自動認識
set fileformats=unix,dos,mac

" 言語固有の設定 ------------------------------------------------------------
" PHP用の設定（参照 :help php-indent）
" PHPでswitch() ブロック内の 'case:' と 'default:' をインデントさせる
let g:PHP_vintage_case_default_indent = 1
" メソッド呼び出しの -> の最初のハイフンが単語と認識されないようにハイフンは除外
autocmd FileType php setlocal iskeyword-=-

" NeoBundle -----------------------------------------------------------------
set nocompatible               " be iMproved
filetype off                   " required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim' " Let NeoBundle manage NeoBundle

NeoBundle 'matchit.zip'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \   'build': {
      \     'mac': 'make -f make_mac.mak',
      \     'linux': 'make',
      \   },
      \ }
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'othree/eregex.vim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tyru/caw.vim.git'
NeoBundle 'vim-scripts/diffchar.vim'
NeoBundle 'vim-scripts/DirDiff.vim'
NeoBundle 'rking/ag.vim'
NeoBundle 'cohama/agit.vim'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'gabrielelana/vim-markdown'
NeoBundle 'vim-scripts/AnsiEsc.vim'
NeoBundle 'itchyny/vim-parenmatch'
NeoBundle 'itchyny/vim-cursorword'

call neobundle#end()

filetype plugin indent on     " required!
NeoBundleCheck

" vim-colors-solarized -----------------------------------------------------------------
let g:solarized_visibility = "low"
let g:solarized_contrast = "high"
set background=dark
colorscheme solarized
" 全角スペースの色
highlight ZenkakuSpace cterm=underline ctermfg=11
match ZenkakuSpace /　/  " スラッシュの間に全角スペース
" タブなどの色
highlight SpecialKey cterm=none ctermfg=10 ctermbg=none
" 改行などの色
highlight NonText cterm=none ctermfg=10
" 検索ヒット部分の色
highlight Search cterm=none ctermfg=0 ctermbg=3
" ビジュアルモードの色
highlight Visual cterm=reverse ctermfg=none ctermbg=none
" vimdiffの色設定
highlight DiffAdd    ctermfg=0 ctermbg=6
highlight DiffChange ctermfg=0 ctermbg=3
highlight DiffDelete ctermfg=1 ctermbg=0
highlight DiffText   ctermfg=0 ctermbg=4

" lightline.vim -----------------------------------------------------------------
" https://github.com/powerline/fonts
"                     Default  powerline
" separator.left      ''       '' (\ue0b0)
" separator.right     ''       '' (\ue0b2)
" subseparator.left   '|'      '' (\ue0b1)
" subseparator.right  '|'      '' (\ue0b3)
" branch symbol       --       '' (\ue0a0)
" readonly symbol     --       '' (\ue0a2)
" linecolumn symbol   --       '' (\ue0a1)
let g:lightline = {
      \   'colorscheme': 'solarized',
      \   'mode_map': { 'c': 'NORMAL' },
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'filetype', 'fileencoding' ] ]
      \   },
      \   'inactive': {
      \     'left': [ [ 'filename' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'filetype' ] ]
      \   },
      \   'component': {
      \     'lineinfo': "\ue0a1" . '%4l/%L:%-3c',
      \   },
      \   'component_function': {
      \     'mode': 'MyMode',
      \     'fugitive': 'MyFugitive',
      \     'filename': 'MyFilename',
      \     'readonly': 'MyReadonly',
      \     'modified': 'MyModified',
      \     'fileencoding': 'MyFileencoding',
      \     'filetype': 'MyFiletype',
      \   },
      \   'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \   'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? "\ue0a2" : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \  &buftype == 'quickfix' ? '[QuickFix]' . (exists('w:quickfix_title') ? ' ' . w:quickfix_title : '') :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ (&buftype == 'help' ? ' [help]' : '') .
        \ (&previewwindow ? ' [Preview]' : '') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? "\ue0a0 "._ : ''
  endif
  return ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) . '[' . &fileformat . ']' : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" eregex.vim -----------------------------------------------------------------
let g:eregex_forward_delim = '/'
let g:eregex_backward_delim = '?'
let g:eregex_replacement = 3

" neocomplete -----------------------------------------------------------------
source ~/.vim/_neocomplete

" unite.vim -----------------------------------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" ステータスラインを上書きしない
let g:unite_force_overwrite_statusline = 0

" vimfiler.vim -----------------------------------------------------------------
nnoremap <silent> <Leader>f :VimFiler<CR>

" syntastic -----------------------------------------------------------------
" let g:syntastic_debug = 32
" let g:syntastic_debug_file = '~/syntastic.log'
let g:syntastic_mode_map = { 'mode': 'active',
      \ 'active_filetypes': [],
      \ 'passive_filetypes': ['rst'] }
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_eruby_ruby_quiet_messages = {
      \ 'regex': '\m^possibly useless use of a \(constant\|variable\) in void context' }

" caw.vim -----------------------------------------------------------------
nmap <Leader>c <Plug>(caw:hatpos:toggle)
vmap <Leader>c <Plug>(caw:hatpos:toggle)
let g:caw_hatpos_skip_blank_line = 1

" diffchar.vim -----------------------------------------------------------------
let g:DiffUnit = 'Word1'
" let g:DiffUpdate = 1  " Ver5.5からデフォルトで有効になった

" ag.vim -----------------------------------------------------------------
command! -nargs=+ -complete=file MyGrep call MyGrep(<f-args>)
nnoremap <Leader>g :MyGrep<Space>
vnoremap <Leader>g y:MyGrep<Space><C-R>"

function! MyGrep(...)
  let l:folder = len(a:000) == 2 ? ' ' . a:2 : ''
  let l:grep_pattern_vim = E2v(a:1)
  execute 'tabedit'
  if executable('ag')
    execute "Ag! '" . a:1 . "'" . l:folder
  else
    execute "vimgrep /" . l:grep_pattern_vim . "/j " . (l:folder == '' ? '.' : l:folder) . '/** | cwindow'
  endif
  if len(getqflist()) == 0
    return
  endif
  execute "nnoremap <silent> <buffer> p :call MyQfCurrentLineFilePreview('" . l:grep_pattern_vim . "')<CR>"
  execute 'nnoremap <buffer> s :QFDo %S/' . l:grep_pattern_vim . '/'
  execute 'vnoremap <buffer> s y:QFDo %S/<C-R>"/'
  execute 'only'
  execute 'setlocal previewheight=' . winheight(0) / 2
  setlocal nowinfixheight
  nnoremap <buffer> h h
  nnoremap <buffer> v v
  nnoremap <buffer> e :QFDo<Space>
  nnoremap <silent> <buffer> q :tabclose<CR>
  nnoremap <silent> <buffer> <Plug>(my:set-hlsearch) :set hlsearch<CR>
  " updatetimeはカーソル移動時に自動読み込みが連続しないような長さに調整する
  execute "autocmd CursorMoved <buffer> if MyDetectCursorChangeLine() | set updatetime=100 | end"
  autocmd CursorHold <buffer> call feedkeys("p\<Plug>(my:set-hlsearch)") | set updatetime=4000
  " カーソル位置を記録するために初期化
  call MyDetectCursorChangeLine()
  " 検索完了後に最初のファイルを表示
  call feedkeys('p')
  call feedkeys("\<Plug>(my:set-hlsearch)")
endfunction

function! MyDetectCursorChangeLine()
  if !exists('b:current_line')
    let b:current_line = line('.')
  endif
  let l:return_val = b:current_line != line('.')
  let b:current_line = line('.')
  return l:return_val
endfunction

function! MyQfCurrentLineFilePreview(grep_pattern)
  let l:target_quickfix = getqflist()[line('.') - 1]
  let l:buffer_number = l:target_quickfix['bufnr']
  let l:target_line = l:target_quickfix['lnum']
  autocmd SwapExists * let v:swapchoice='o'
  silent execute 'pedit +setlocal\ nowinfixheight|setlocal\ cursorline|' . l:target_line . '|normal\ zz ' . bufname(l:buffer_number)
  autocmd! SwapExists
  call lightline#update()
  let @/ = a:grep_pattern
  setlocal cursorline
  highlight CursorLineNr ctermfg=228
  highlight CursorLine ctermbg=236
endfunction

" agit -----------------------------------------------------------------
let g:agit_stat_width = 130

" vim-markdown -----------------------------------------------------------------
let g:markdown_enable_spell_checking = 0

" vim-parenmatch -----------------------------------------------------------------
let g:loaded_matchparen = 1
