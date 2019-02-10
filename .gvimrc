let s:env = VimrcEnvironment()


if has('gui_running')
  " Font {{{
  if s:env.is_win
    set guifont=Ricty_Diminished_Discord:h12
  elseif s:env.is_mac
    set guifont=Ricty_Diminished_Discord:h16
  endif
  " }}}

  " window size {{{
  " height
  set lines=48
  " width
  set columns=148
  " }}}

  " fzf {{{
  if executable('rg') && s:env.is_unix
    let $FZF_DEFAULT_COMMAND="rg --files --follow --hidden -g '!**/.git/*' 2>/dev/null"
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
  set visualbell t_vb=
  " }}}
endif
