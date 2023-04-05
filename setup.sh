#!/bin/sh

REPOSITORY_DIR=$(cd $(dirname $0); pwd)

ln -sf $REPOSITORY_DIR/.gitconfig $HOME/.gitconfig
ln -sf $REPOSITORY_DIR/.vimrc $HOME/.vimrc
ln -sf $REPOSITORY_DIR/.gvimrc $HOME/.gvimrc

ASTRO_NVIM_DIR=$HOME/.config/nvim/lua
if [ ! -d ${ASTRO_NVIM_DIR} ]; then
    mkdir -p $ASTRO_NVIM_DIR
fi
if [ -d ${ASTRO_NVIM_DIR}/user ]; then
    rm -rf ${ASTRO_NVIM_DIR}/user
fi
ln -sf $REPOSITORY_DIR/astronvim_config $ASTRO_NVIM_DIR/user
