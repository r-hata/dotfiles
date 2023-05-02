#!/bin/bash
set -eo pipefail

LN_OPTION="-s${OPTION}"

REPOSITORY_DIR=$(
	cd "$(dirname "$0")"
	pwd
)

ln "$LN_OPTION" "$REPOSITORY_DIR"/.gitconfig "$HOME"/.gitconfig
ln "$LN_OPTION" "$REPOSITORY_DIR"/.vimrc "$HOME"/.vi
ln "$LN_OPTION" "$REPOSITORY_DIR"/.gvimrc "$HOME"/.gvimrc

DOT_CONFIG_DIR=$HOME/.config
LAZYGIT_DIR=$DOT_CONFIG_DIR/lazygit
if [ ! -d "${LAZYGIT_DIR}" ]; then
	mkdir -p "$LAZYGIT_DIR"
fi
ln "$LN_OPTION" "$REPOSITORY_DIR"/lazygit/config.yml "$LAZYGIT_DIR"/config.yml

ASTRO_NVIM_DIR=$DOT_CONFIG_DIR/nvim/lua
if [ ! -d "${ASTRO_NVIM_DIR}" ]; then
	mkdir -p "$ASTRO_NVIM_DIR"
fi
if [ -d "${ASTRO_NVIM_DIR}"/user ]; then
	if [ "$OPTION" != "f" ]; then
		read -r -p "overwrite '${ASTRO_NVIM_DIR}/user'? (y/N): " yn
		case "$yn" in [yY]*) ;; *) exit ;; esac
	fi
	rm -rf "${ASTRO_NVIM_DIR}"/user
fi
ln "$LN_OPTION" "$REPOSITORY_DIR"/astronvim_config "$ASTRO_NVIM_DIR"/user
