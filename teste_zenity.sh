#!/bin/bash

NOME=`zenity --entry --text "Digite seu nome:"`

DATA=`zenity --calendar --title "Data de nascimento:"`

zenity --info --text "Seu nome é $NOME e voce nasceu em $DATA"
