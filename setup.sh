#!/bin/sh

REPOSITORY_DIR=$(cd $(dirname $0); pwd)

ln -s $REPOSITORY_DIR/.gitconfig $HOME/.gitconfig
ln -s $REPOSITORY_DIR/.vimrc $HOME/.vimrc
ln -s $REPOSITORY_DIR/.gvimrc $HOME/.gvimrc
ln -s $REPOSITORY_DIR/.tmux.conf $HOME/.tmux.conf

NVIM_CONFIG_DIR=$HOME/.config/nvim
if [ ! -d ${NVIM_CONFIG_DIR} ]; then
    mkdir -p $NVIM_CONFIG_DIR
fi
ln -s $REPOSITORY_DIR/.vimrc $NVIM_CONFIG_DIR/init.vim
