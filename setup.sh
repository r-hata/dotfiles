#!/bin/bash
set -eo pipefail

LN_OPTION="-s${OPTION}"

REPOSITORY_DIR=$(
	cd "$(dirname "$0")"
	pwd
)

ln "$LN_OPTION" "$REPOSITORY_DIR"/.gitconfig "$HOME"/.gitconfig

DOT_CONFIG_DIR=$HOME/.config
LAZYGIT_DIR=$DOT_CONFIG_DIR/lazygit
if [ ! -d "${LAZYGIT_DIR}" ]; then
	mkdir -p "$LAZYGIT_DIR"
fi
ln "$LN_OPTION" "$REPOSITORY_DIR"/lazygit/config.yml "$LAZYGIT_DIR"/config.yml
FISH_DIR=$DOT_CONFIG_DIR/fish
if [ ! -d "${FISH_DIR}" ]; then
	mkdir -p "$FISH_DIR"
fi
ln "$LN_OPTION" "$REPOSITORY_DIR"/fish/config.fish "$FISH_DIR"

NVIM_DIR=$DOT_CONFIG_DIR/nvim
ln "$LN_OPTION" "$REPOSITORY_DIR"/astronvim_config "$NVIM_DIR"
