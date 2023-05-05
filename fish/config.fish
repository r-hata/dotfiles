if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Install fisher
# curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# Install fisher plugins
# fisher install pure-fish/pure
# fisher install edc/bass
# fisher install jorgebucaran/nvm.fish
# fisher install rbenv/fish-rbenv
# fisher install halostatue/fish-rust

# ---------------------------------------
# PATH settings
# ---------------------------------------
# Initialize linuxbrew
if test "/home/linuxbrew"
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Initialize golang
if test "$HOME/go"
  fish_add_path $HOME/go/bin
end

# Add ~/.local/bin to PATH
if test "$HOME/.local/bin"
  fish_add_path $HOME/.local/bin
end

# ---------------------------------------
# Alias settings
# ---------------------------------------
# ls
if command -sq exa
  alias l='exa --icons -1a'
  alias ls='exa --icons'
  alias ll='exa --icons -lh'
  alias la='exa --icons -lha'
else
  alias ls='ls --color=auto -F'
end

# ---------------------------------------
# Plugin settings
# ---------------------------------------
# fzf
# Install fzf
# brew install fzf
# (brew --prefix)/opt/fzf/install
if command -sq fd
  set -gx FZF_DEFAULT_COMMAND "fd --type f --follow --hidden --exclude '**/.git/*' 2>/dev/null"
  set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
else if command -sq rg
  set -gx FZF_DEFAULT_COMMAND "rg --files --follow --hidden --glob '!**/.git/*' 2>/dev/null"
  set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
end
