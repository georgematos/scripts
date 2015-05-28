#!/bin/bash
ORIGEM="/home/george/Desenvolvimento/Wiki_Bentham/"
DESTINO="/media/george/PENDRIVE/Quanta/Wiki_Bentham/"

cp -Rf $ORIGEM/* $DESTINO

if [ $? -eq 0 ]; then
  zenity --info --text "Sincronização concluída!"
else
  zenity --info --text "Ocorreu um erro!"
fi
