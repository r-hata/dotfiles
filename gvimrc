let s:env = VimrcEnvironment()


if has('gui_running')
  " Font
  if s:env.is_win
    set guifont=Ricty_Diminished_for_Powerline:h12
  endif

  " window size
  " height
  set lines=40
  " width
  set columns=120

  " Misc
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set guioptions-=b
  set visualbell t_vb=
endif
