#!/bin/bash

echo "Adicione 'deb http://downloads.hipchat.com/linux/apt stable main' em /etc/apt/sources.list.d/atlassian-hipchat.list antes de executar esse script"
echo -n "Continuar? Se já houver concluído o passo acima digite 'sim' "
read CONTINUA;

if [ "$CONTINUA" == "sim" ]
then
  sudo wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -
  sudo apt-get update
  sudo apt-get install hipchat
else
  echo "Ok, estarei esperando =) ..."
fi