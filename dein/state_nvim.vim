if g:dein#_cache_version != 100 | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/Ryosuke/.config/nvim/init.vim'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/Ryosuke/.config/nvim/dein'
let g:dein#_runtime_path = '/Users/Ryosuke/.config/nvim/dein/.cache/init.vim/.dein'
let g:dein#_cache_path = '/Users/Ryosuke/.config/nvim/dein/.cache/init.vim'
let &runtimepath = '/Users/Ryosuke/.config/nvim,/etc/xdg/nvim,/Users/Ryosuke/.local/share/nvim/site,/usr/local/share/nvim/site,/Users/Ryosuke/.config/nvim/dein/repos/github.com/Shougo/dein.vim,/Users/Ryosuke/.config/nvim/dein/.cache/init.vim/.dein,/usr/share/nvim/site,/usr/local/Cellar/neovim/0.2.0/share/nvim/runtime,/Users/Ryosuke/.config/nvim/dein/.cache/init.vim/.dein/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/Ryosuke/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/Ryosuke/.config/nvim/after'
filetype off
