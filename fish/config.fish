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
  # fisher install jethrokuan/fzf
  # fisher install jethrokuan/z

  # ---------------------------------------
  # PATH settings
  # ---------------------------------------
  # Initialize linuxbrew
  if test -d "/home/linuxbrew"
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  else if test -d "/opt/homebrew"
    eval (/opt/homebrew/bin/brew shellenv)
  end

  # Initialize golang
  fish_add_path $HOME/go/bin

  # Add ~/.local/bin to PATH
  fish_add_path $HOME/.local/bin

  # pyenv
  if command -sq pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    pyenv init - | source
  end

  # ---------------------------------------
  # Alias settings
  # ---------------------------------------
  # ls
  if command -sq eza
    alias ls='eza --icons'
    set allopt 'a'
  else
    alias ls='ls --color=auto -F'
    set allopt 'A'
  end
  alias l="ls -1$allopt"
  alias ll="ls -lh"
  alias la="ls -lh$allopt"
  alias rm="rm -i"

  # ---------------------------------------
  # Plugin settings
  # ---------------------------------------
  # fzf
  # Install fzf
  # brew install fzf
  # (brew --prefix)/opt/fzf/install
  set -U FZF_LEGACY_KEYBINDINGS 0
  set -U EDITOR "nvim"
  set -U FZF_REVERSE_ISEARCH_OPTS "--reverse"
  if command -sq fd
    set -U FZF_FIND_FILE_COMMAND "fd --type f --follow --hidden --exclude '**/.git/*' 2>/dev/null"
  else if command -sq rg
    set -U FZF_FIND_FILE_COMMAND "rg --files --follow --hidden --glob '!**/.git/*' 2>/dev/null"
  end

  # nvm
  if test -d "$HOME/.nvm"
    set -gx NVM_DIR "$HOME/.nvm"
  end
end
