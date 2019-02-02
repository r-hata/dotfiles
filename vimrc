" Encoding {{{
set encoding=utf-8
scriptencoding utf-8
" }}}

" Environment {{{
function! VimrcEnvironment()
  let env = {}
  let env.is_unix = has('unix')
  let env.is_win = has('win32')

  let user_dir = env.is_win
        \ ? expand('$VIM/vimfiles')
        \ : expand('~/.vim')
  let env.path = {
        \   'user':          user_dir,
        \   'plugins':       user_dir . '/plugins',
        \   'plug_preset':   user_dir . '/plug-preset.vim',
        \   'data':          user_dir . '/data',
        \   'local_vimrc':   user_dir . '/.vimrc_local',
        \   'tmp':           user_dir . '/tmp',
        \   'undo':          user_dir . '/data/undo',
        \   'vim_plug':      user_dir . '/vim-plug',
        \ }

  return env
endfunction

let s:env = VimrcEnvironment()
" }}}

" Plugins {{{
let s:plugins = [
  \ 'AndrewRadev/linediff.vim',
  \ 'LeafCage/yankround.vim',
  \ 'Shougo/context_filetype.vim',
  \ 'Shougo/deoplete.nvim',
  \ 'Shougo/neosnippet',
  \ 'Shougo/neosnippet-snippets',
  \ 'airblade/vim-gitgutter',
  \ 'bronson/vim-trailing-whitespace',
  \ 'cespare/vim-toml',
  \ 'cocopon/iceberg.vim',
  \ 'cocopon/vaffle.vim',
  \ 'cohama/lexima.vim',
  \ 'digitaltoad/vim-pug',
  \ 'easymotion/vim-easymotion',
  \ 'fatih/vim-go',
  \ 'godlygeek/tabular',
  \ 'itchyny/lightline.vim',
  \ 'junegunn/fzf',
  \ 'junegunn/fzf.vim',
  \ 'kana/vim-operator-user',
  \ 'lilydjwg/colorizer',
  \ 'luochen1990/rainbow',
  \ 'osyo-manga/vim-operator-search',
  \ 'osyo-manga/vim-precious',
  \ 'othree/html5.vim',
  \ 'pangloss/vim-javascript',
  \ 'posva/vim-vue',
  \ 'roxma/nvim-yarp',
  \ 'roxma/vim-hug-neovim-rpc',
  \ 'tpope/vim-fugitive',
  \ 'tpope/vim-markdown',
  \ 'tpope/vim-surround',
  \ 'tyru/restart.vim',
  \ 'vim-jp/vimdoc-ja',
  \ ]
let s:colorscheme = 'iceberg'
" }}}

" Setup {{{
function! VimrcSetUp()
  call s:install_plugin_manager()
endfunction
" }}}


" Installation {{{
function! s:mkdir_if_needed(dir)
  if isdirectory(a:dir)
    return 0
  endif

  call mkdir(a:dir, 'p')
  return 1
endfunction

function! s:install_plugins()
  call s:mkdir_if_needed(s:env.path.plugins)

  if exists(':PlugInstall')
    PlugInstall
    return 1
  endif

  return 0
endfunction

function! s:clone_repository(url, local_path)
  if isdirectory(a:local_path)
    return
  endif

  execute printf('!git clone %s %s', a:url, a:local_path)
endfunction

function! s:install_plugin_manager()
  call s:mkdir_if_needed(s:env.path.user)
  call s:mkdir_if_needed(s:env.path.data)

  call s:clone_repository(
        \ 'https://github.com/junegunn/vim-plug',
        \ s:env.path.vim_plug . '/autoload')
  call s:clone_repository(
        \ 'https://github.com/r-hata/plug-preset.vim',
        \ s:env.path.plug_preset)

  if !s:activate_plugin_manager()
    return 0
  endif

  if !s:install_plugins()
    return 0
  endif

  echo 'Restart vim to finish the installation.'
  return 1
endfunction
" }}}


" Activation {{{
function! s:load_plugin(path)
  try
    execute 'set runtimepath+=' . a:path

    return 1
  catch /:E117:/
    " E117: Unknown function
    return 0
  endtry
endfunction

function! s:activate_plugins()
  if !exists(':Plug')
    " Plugin manager is not installed yet
    return 0
  endif

  let command = exists(':PresetPlug')
        \ ? 'PresetPlug'
        \ : 'Plug'

  for plugin in s:plugins
    execute printf("%s '%s'", command, plugin)
  endfor

  return 1
endfunction

function! s:activate_plugin_manager_internal()
  " Activate plugin manager
  if !exists(':Plug')
    execute 'set runtimepath+=' . s:env.path.vim_plug
  endif
  call plug#begin(s:env.path.plugins)

  try
    " Activate PresetPlug
    if !exists(':PresetPlug')
      execute 'set runtimepath+=' . s:env.path.plug_preset
    endif
    call plug_preset#init()

    " Activate plugins
    return s:activate_plugins()
  finally
    call plug#end()
    filetype indent on
    filetype plugin on
  endtry
endfunction

function! s:activate_plugin_manager()
  try
    return s:activate_plugin_manager_internal()
  catch /:E117:/
    " E117: Unknown function
    " Plugin manager is not installed yet
    return 0
  endtry
endfunction
" }}}

" Initialization {{{
call s:mkdir_if_needed(s:env.path.tmp)
call s:mkdir_if_needed(s:env.path.undo)
let s:plugins_activated = s:activate_plugin_manager()
" }}}

" Key mapping {{{
" ターミナルモードでEscによりノーマルモードへ
tnoremap <silent> <ESC> <C-\><C-n>0
" 新しいタブを開く
nnoremap <C-t> :tabnew<CR>
" 一つ前のタグスタックにジャンプする
nnoremap <C-Left> :pop<CR>
" ハイライトオフ
nnoremap <silent> <CR> :nohl<CR>
" Delete代替
inoremap <C-l> <Del>
" Insertモード時のEsc代替
inoremap jj <ESC>
" tagjump
nnoremap <C-]> g<C-]>
nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>
" }}}

" Indent {{{
" http://peace-pipe.blogspot.com/2006/05/vimrc-vim.html
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" }}}

" File types {{{
if has("autocmd")
  " sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType html  setlocal sw=0 sts=2 ts=2 et
  autocmd FileType ruby  setlocal sw=0 sts=2 ts=2 et
  autocmd FileType scss  setlocal sw=0 sts=2 ts=2 et
  autocmd FileType css   setlocal sw=0 sts=2 ts=2 et
  autocmd FileType eruby setlocal sw=0 sts=2 ts=2 et
  autocmd FileType vim   setlocal sw=0 sts=2 ts=2 et
  autocmd FileType zsh   setlocal sw=0 sts=2 ts=2 et
  autocmd FileType pug   setlocal sw=0 sts=2 ts=2 et
  autocmd FileType vue   setlocal sw=0 sts=2 ts=2 et
endif
" }}}

" Search {{{
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
" }}}

" Backup {{{
set nobackup
set noswapfile
let &undodir = s:env.path.undo
set undofile
" }}}

" Appearance {{{
" 行番号・ルーラーの表示
set number
set ruler
" 上下8行の視界を確保
set scrolloff=8
set sidescrolloff=16
" 左右スクロールは一文字づつ行う
set sidescroll=1
" カレント行をハイライト
set cursorline
" 空白文字を可視化
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" ステータス行を2行にする
set laststatus=2
" Insertモード時、"-- 挿入 --"を非表示にする
set noshowmode
" set gui colors on cui vim
if exists('$TMUX')
  " Colors in tmux
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors
set background=dark
" }}}

" Cursor {{{
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif
" Backspaceキーの影響範囲に制限を設けない
set backspace=indent,eol,start
" 行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]
" }}}

" Misc {{{
" 保存されていないファイルがある時終了前に保存確認
set confirm
" 外部からファイルが変更された時自動で更新
set autoread
" バッファ切替時に保存の確認をしない
set hidden
" ビープ音をすべて無効にする
set visualbell t_vb=
" エラーメッセージの表示時にビープを鳴らさない
set noerrorbells
" クリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus
" Windows でもパスの区切り文字を / にする
set shellslash
" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=longest,full
" コマンドラインの履歴を10000件保存する
set history=10000
" }}}

" Color hex to func {{{
function! HexToFunc(hex)
  let color = matchlist(a:hex, '\([0-9A-F]\{2\}\)\([0-9A-F]\{2\}\)\([0-9A-F]\{2\}\)')
  return 'rgb(' . printf('%d', '0x' . color[1]) . ', ' . printf('%d', '0x' . color[2]) . ', ' . printf('%d', '0x' . color[3]) . ')'
endfunction

command!
\   HexToFunc
\   :%s/\(#[0-9A-F]\{6\}\)/\=HexToFunc(submatch(1))/gi
" }}}

" Plugin settings {{{
if s:plugins_activated
  " easymotion {{{
  map <Space><Space> <Plug>(easymotion-prefix)
  " }}}

  " yankround {{{
  nmap p <Plug>(yankround-p)
  xmap p <Plug>(yankround-p)
  nmap P <Plug>(yankround-P)
  nmap gp <Plug>(yankround-gp)
  xmap gp <Plug>(yankround-gp)
  nmap gP <Plug>(yankround-gP)
  nmap <C-p> <Plug>(yankround-prev)
  nmap <C-n> <Plug>(yankround-next)
  " }}}

  " lightline {{{
  let g:lightline = {
    \ 'colorscheme': s:colorscheme,
    \ 'active': {
    \   'left': [
    \   [ 'mode', 'paste' ],
    \   [ 'gitbranch', 'readonly', 'filename', 'modified' ]
    \ ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'LightlineGitHead',
    \   'filename': 'LightlineFilename'
    \ }
    \ }

  function! LightlineFilename()
    let l:head = fugitive#head()
    let l:filename = expand('%:t')
    let l:relative_path_filename = expand('%:s')
    let l:head_len = strlen(l:head)
    let l:filename_len = strlen(l:filename)
    let l:path_len = strlen(l:relative_path_filename)
    let l:MARGIN = 50
    let l:width = winwidth(0)

    if l:width > l:head_len + l:filename_len + l:MARGIN
      if '' != l:filename
        if l:width > l:head_len + l:path_len + l:MARGIN
          return l:relative_path_filename
        else
          return l:filename
        endif
      else
        return '[No Name]'
      endif
    else
      return ''
    endif
  endfunction

  function! LightlineGitHead()
    let l:head = fugitive#head()
    let l:filename = expand('%:t')
    let l:head_len = strlen(l:head)
    let l:filename_len = strlen(l:filename)
    let l:MARGIN = 50

    if winwidth(0) > l:head_len + l:filename_len + l:MARGIN
      return l:head
    else
      return ''
    endif
  endfunction
  " }}}

  " fzf.vim {{{
  nnoremap <silent> <C-c> :FZF<CR>
  nnoremap <silent> <C-b> :Buffers<CR>
  " }}}

  " rainbow {{{
  let g:rainbow_active = 1
  " }}}

  " restart.vim {{{
  command!
  \   -bar
  \   RestartWithSession
  \   let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
  \   | Restart
  " }}}

  " vim-operator-search {{{
  nmap <Space>s <Plug>(operator-search)
  nmap <Space>/ <Plug>(operator-search)if
  " }}}

  " deoplete {{{
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_complete = 0
  let g:deoplete#enable_refresh_always = 0
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
  function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction "}}}
  " }}}

  " neosnippet {{{
  " Plugin key-mappings.
  " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)

  " SuperTab like snippets behavior.
  " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
  "imap <expr><TAB>
  " \ pumvisible() ? "\<C-n>" :
  " \ neosnippet#expandable_or_jumpable() ?
  " \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

  " For conceal markers.
  if has('conceal')
    set conceallevel=2 concealcursor=niv
  endif
  " }}}

  " Japaneseization of help doc {{{
  set helplang=ja,en
  " }}}
endif
" }}}

" Local settings {{{
if filereadable(s:env.path.local_vimrc)
	execute 'source ' . s:env.path.local_vimrc
endif
" }}}

" Color scheme {{{
if s:plugins_activated
  if !has('gui_running')
    syntax enable
    execute printf('colorscheme %s', s:colorscheme)
  else
    augroup vimrc_colorscheme
      autocmd!
      execute printf('autocmd GUIEnter * colorscheme %s', s:colorscheme)
    augroup END
  endif
endif
" }}}

