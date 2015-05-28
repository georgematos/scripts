#!/bin/zsh

DIR_TEMPLATES="/home/$USER/Desenvolvimento/workspace/bentham/src/main/webapp/templates_angularjs"
DIR=$DIR_TEMPLATES/$1

if [ -d $DIR ]; then
  jade -w $DIR/*
else
  echo
  echo "O módulo  não existe:\n \033[01;31m$DIR\033[01;31m"
  echo
  exit 1
fi
