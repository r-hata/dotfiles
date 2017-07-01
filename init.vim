"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/Ryosuke/.config/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/Ryosuke/.config/nvim/dein')
  call dein#begin('/Users/Ryosuke/.config/nvim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/Ryosuke/.config/nvim/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  "カラースキーム
  call dein#add('tomasr/molokai')
  "ファイル遷移
  call dein#add('Shougo/denite.nvim')
  "deniteの前提プラグイン
  call dein#add('Shougo/vimproc.vim')
  "gitプラグイン
  call dein#add('tpope/vim-fugitive')
  "閉じ括弧、2個目のクォーテーションを自動入力
  call dein#add('cohama/lexima.vim')
  "ステータスラインの表示を強化
  call dein#add('itchyny/lightline.vim')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

" 不可視文字を表示
set list
" 不可視文字の表示記号指定
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮

"Backspaceキーの影響範囲に制限を設けない
set backspace=indent,eol,start
"行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]

"カラースキーマを設定
colorscheme molokai
" 256色¬
set t_Co=256¬

"行番号・ルーラーの表示
set number
set ruler

"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab

"タブ幅の設定（下記参照）
"http://peace-pipe.blogspot.com/2006/05/vimrc-vim.html
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType html setlocal sw=0 sts=2 ts=2 et
  autocmd FileType ruby setlocal sw=0 sts=2 ts=2 et
  autocmd FileType scss setlocal sw=0 sts=2 ts=2 et
  autocmd FileType css  setlocal sw=0 sts=2 ts=2 et
  autocmd FileType erb  setlocal sw=0 sts=2 ts=2 et
endif

"検索文字列をハイライトする↲
set hlsearch
"インクリメンタルサーチを有効にする
set incsearch
"大文字小文字を区別しない
set ignorecase
"大文字で検索されたら対象を大文字限定にする
set smartcase
"行末まで検索したら行頭に戻る
set wrapscan

"バックアップファイルを作成しない
set nobackup
"編集中のスワップファイルを作成しない
set noswapfile
"保存されていないファイルがある時終了前に保存確認
set confirm
"外部からファイルが変更された時自動で更新
set autoread

"ビープ音すべてを無効にする
set visualbell t_vb=
"エラーメッセージの表示時にビープを鳴らさない
set noerrorbells

"コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
"コマンドラインの履歴を10000件保存する
set history=10000

"OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus
"Windows でもパスの区切り文字を / にする
set shellslash

"上下8行の視界を確保
set scrolloff=8
set sidescrolloff=16
"左右スクロールは一文字づつ行う
set sidescroll=1
"マウス無効
set mouse=
