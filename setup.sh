#!/bin/sh

REPOSITORY_DIR=$(cd $(dirname $0); pwd)

ln -s $REPOSITORY_DIR/gitconfig $HOME/.gitconfig
ln -s $REPOSITORY_DIR/vimrc $HOME/.vimrc
ln -s $REPOSITORY_DIR/gvimrc $HOME/.gvimrc
