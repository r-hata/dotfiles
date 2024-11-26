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

ASTRO_NVIM_DIR=$DOT_CONFIG_DIR/nvim
if [ -d "${ASTRO_NVIM_DIR}" ]; then
	if [ "$OPTION" != "f" ]; then
		read -r -p "overwrite '${ASTRO_NVIM_DIR}'? (y/N): " yn
		case "$yn" in [yY]*) ;; *) exit ;; esac
	fi
	rm -rf "${ASTRO_NVIM_DIR}"
fi
ln "$LN_OPTION" "$REPOSITORY_DIR"/astronvim_config "$ASTRO_NVIM_DIR"
