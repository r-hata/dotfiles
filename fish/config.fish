if status is-interactive
  # Commands to run in interactive sessions can go here

  # Install fisher
  # curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  # Install fisher plugins
  # fisher install pure-fish/pure
  # fisher install edc/bass
  # fisher install FabioAntunes/fish-nvm
  # fisher install rbenv/fish-rbenv
  # fisher install halostatue/fish-rust

  # ---------------------------------------
  # PATH settings
  # ---------------------------------------
  # Initialize linuxbrew
  if test -d "/home/linuxbrew"
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  end

  # Initialize golang
  if test -d "$HOME/go"
    fish_add_path $HOME/go/bin
  end

  # Add ~/.local/bin to PATH
  if test -d "$HOME/.local/bin"
    fish_add_path $HOME/.local/bin
  end

  # ---------------------------------------
  # Alias settings
  # ---------------------------------------
  # ls
  if command -sq exa
    alias ls='exa --icons'
    set allopt 'a'
  else
    alias ls='ls --color=auto -F'
    set allopt 'A'
  end
  alias l="ls -1$allopt"
  alias ll="ls -lh"
  alias la="ls -lh$allopt"

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

  # nvm
  if test -d "$HOME/.nvm"
    set -gx NVM_DIR "$HOME/.nvm"
  end
end
