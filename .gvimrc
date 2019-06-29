let s:env = VimrcEnvironment()


" Font {{{
if s:env.is_win
  set guifont=HackGen_Console:h12
elseif s:env.is_mac
  set guifont=HackGen_Console:h16
endif
" }}}

" window size {{{
" height
set lines=48
" width
set columns=148
" }}}

" fzf {{{
if executable('rg')
  if s:env.is_win
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case "'.<q-args>.'"', 1,
      \   <bang>0)
  endif

  if s:env.is_unix
    let $FZF_DEFAULT_COMMAND="rg --files --follow --hidden --glob '!**/.git/*' 2>/dev/null"
  endif
endif
" }}}

" Misc {{{
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b
set background=dark
" }}}

