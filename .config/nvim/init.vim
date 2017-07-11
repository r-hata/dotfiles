" python3の有効化
if has('mac')
  let g:python3_host_prog = expand('/Users/Ryosuke/anaconda2/envs/python3/bin/python')
elseif has('unix')
  let g:python3_host_prog = expand('/usr/bin/python3')
endif

"dein Scripts-----------------------------
" Required:
if !&compatible
  set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
let s:lazy_toml_file = fnamemodify(expand('<sfile>'), ':h').'/lazy.toml'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  " tomlファイル読み込み
  call dein#load_toml(s:toml_file,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml_file, {'lazy': 1})
  if has('python3')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/denite.nvim')
  end
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

" Key mapping-----------------------------
inoremap <C-r> <ESC>o

" easymotion modifiable
map <Leader> <Plug>(easymotion-prefix)

" denite起動時に使用するキーマップ
" バッファ一覧
noremap <C-p> :Denite buffer<CR>
" ファイル一覧
noremap <C-n> :Denite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-z> :Denite file_old<CR>
" カレントディレクトリ
noremap <C-c> :Denite file_rec<CR>
" ハイライトオフ
nnoremap <ESC><ESC> :nohl<CR>
" End key mapping-------------------------

" lightline settings----------------------
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [
  \   [ 'mode', 'paste' ],
  \   [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \ ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \ }
  \ }
" End lightline settings------------------

" 不可視文字を表示
set list
" 不可視文字の表示記号指定
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮

" Backspaceキーの影響範囲に制限を設けない
set backspace=indent,eol,start
" 行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]

" 256色
set t_Co=256

" 行番号・ルーラーの表示
set number
set ruler

" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab

" タブ幅の設定（下記参照）
" http://peace-pipe.blogspot.com/2006/05/vimrc-vim.html
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab

if has("autocmd")
  " ファイルタイプの検索を有効にする
  filetype plugin on
  " ファイルタイプに合わせたインデントを利用
  filetype indent on
  " sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType html  setlocal sw=0 sts=2 ts=2 et
  autocmd FileType ruby  setlocal sw=0 sts=2 ts=2 et
  autocmd FileType scss  setlocal sw=0 sts=2 ts=2 et
  autocmd FileType css   setlocal sw=0 sts=2 ts=2 et
  autocmd FileType eruby setlocal sw=0 sts=2 ts=2 et
  autocmd FileType vim   setlocal sw=0 sts=2 ts=2 et
endif

" 検索文字列をハイライトする↲
set hlsearch
" インクリメンタルサーチを有効にする
set incsearch
" 大文字小文字を区別しない
set ignorecase
" 大文字で検索されたら対象を大文字限定にする
set smartcase
" 行末まで検索したら行頭に戻る
set wrapscan

" バックアップファイルを作成しない
set nobackup
" 編集中のスワップファイルを作成しない
set noswapfile
" 保存されていないファイルがある時終了前に保存確認
set confirm
" 外部からファイルが変更された時自動で更新
set autoread

" ビープ音すべてを無効にする
set visualbell t_vb=
" エラーメッセージの表示時にビープを鳴らさない
set noerrorbells

" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full

" コマンドラインの履歴を10000件保存する
set history=10000

" OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus
" Windows でもパスの区切り文字を / にする
set shellslash

" 上下8行の視界を確保
set scrolloff=8
set sidescrolloff=16
" 左右スクロールは一文字づつ行う
set sidescroll=1
" マウス無効
set mouse=
" カレント行をハイライト
set cursorline
" auto-ctagsを使ってファイル保存時にtagsファイルを更新
let g:auto_ctags = 1

