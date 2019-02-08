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
  \ 'Shougo/vimproc.vim',
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
  \ 'thinca/vim-quickrun',
  \ 'tpope/vim-fugitive',
  \ 'tpope/vim-markdown',
  \ 'tpope/vim-surround',
  \ 'tyru/restart.vim',
  \ 'vim-airline/vim-airline',
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
" In TERMINAL mode, press Esc key to go to NORMAL mode
tnoremap <silent> <ESC> <C-\><C-n>0

nnoremap <C-t> :tabnew<CR>
nnoremap <silent> <CR> :nohlsearch<CR>
inoremap <C-l> <Del>
inoremap jj <ESC>

" tagjump
nnoremap <C-]> g<C-]>
nnoremap <C-h> :vsplit<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-Left> :pop<CR>

" For US keyboard
nnoremap ; :
" }}}

" Indent {{{
" http://peace-pipe.blogspot.com/2006/05/vimrc-vim.html
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab
set smarttab
" }}}

" File types {{{
augroup vimrc
  autocmd!
  autocmd FileType html  setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType ruby  setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType scss  setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType css   setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType eruby setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType vim   setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType zsh   setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType pug   setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
  autocmd FileType vue   setlocal softtabstop=0 shiftwidth=2 tabstop=2 expandtab
augroup END
" }}}

" Search {{{
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
" }}}

" Backup {{{
set nobackup
set noswapfile
let &undodir = s:env.path.undo
set undofile
" }}}

" Appearance {{{
set number
set ruler
set scrolloff=8
set sidescrolloff=16
set sidescroll=1
set cursorline
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set laststatus=2
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
    " Non blink vertical bar type cursor on INSERT mode
    let &t_SI .= "\e[6 q"
    " Non blink block type cursor on NORMAL mode
    let &t_EI .= "\e[2 q"
    " Non blink underscore type cursor on REPLACE mode
    let &t_SR .= "\e[4 q"
endif
" Enable cursor across lines
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
" }}}

" Misc {{{
set confirm
set autoread
set hidden
set visualbell t_vb=
set noerrorbells
set clipboard=unnamed,unnamedplus
" Make Windows path separator slash
set shellslash
set wildmenu wildmode=longest,full
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

  " quickrun {{{
  " Asynchronous execution by vimproc
  " Display buffers on success, display Quickfix on failure
  " Resize result window
  let g:quickrun_config = {
      \ '_' : {
          \ 'runner' : 'vimproc',
          \ 'runner/vimproc/updatetime' : 40,
          \ 'outputter' : 'error',
          \ 'outputter/error/success' : 'buffer',
          \ 'outputter/error/error'   : 'quickfix',
          \ 'outputter/buffer/split' : ':botright 8sp',
      \ }
  \}

  " Save the buffer, close the previous result and execute
  let g:quickrun_no_default_key_mappings = 1
  nmap <Leader>r :cclose<CR>:write<CR>:QuickRun -mode n<CR>
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
