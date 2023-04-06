#!/bin/bash
set -eo pipefail

LN_OPTION="-s${OPTION}"

REPOSITORY_DIR=$(cd $(dirname $0); pwd)

ln $LN_OPTION $REPOSITORY_DIR/.gitconfig $HOME/.gitconfig
ln $LN_OPTION $REPOSITORY_DIR/.vimrc $HOME/.vimrc
ln $LN_OPTION $REPOSITORY_DIR/.gvimrc $HOME/.gvimrc

ASTRO_NVIM_DIR=$HOME/.config/nvim/lua
if [ ! -d ${ASTRO_NVIM_DIR} ]; then
    mkdir -p $ASTRO_NVIM_DIR
fi
if [ -d ${ASTRO_NVIM_DIR}/user ]; then
    if [ $OPTION != "f" ]; then
      read -p "overwrite '${ASTRO_NVIM_DIR}/user'? (y/N): " yn
      case "$yn" in [yY]*) ;; *) exit ;; esac
    fi
    rm -rf ${ASTRO_NVIM_DIR}/user
fi
ln $LN_OPTION $REPOSITORY_DIR/astronvim_config $ASTRO_NVIM_DIR/user
