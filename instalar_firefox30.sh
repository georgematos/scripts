#!/bin/bash

install() {
  if [ -d "/opt/firefox30" ]
  then
    echo "Excluindo instalação antiga..."
    sudo rm -fr /opt/firefox30
  fi

  echo "Iniciando instalação..."
  tar -xjvf firefox-30.0.tar.bz2
  sudo mv -f firefox /opt/firefox30
  sudo mv -f /usr/bin/firefox /usr/bin/firefox_backup
  sudo ln -sf /opt/firefox30/firefox /usr/bin/firefox
}

clean() {
  read -p "Deseja excluir os arquivos baixados? (S/n)" OPTION # Lê do teclado e já insere na variável
  OPTION=${OPTION:-S} # Configura opção padrão
  if [ $OPTION = "S" -o $OPTION = "s" ]
  then
    rm firefox-30.0.tar.bz2
  else
    exit
  fi
}

read -p "Esse script irá sobrepor qualquer versão do Firefox em sua máquina para a versão 30.0. Continuar? (N/s)" OPTION
OPTION=${OPTION:-N}
if [ $OPTION = "S" -o $OPTION = "s" ]
then
  if [ -e ./firefox-30.0.tar.bz2 ]
  then
      install
      clean
  else
      wget ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/30.0/linux-x86_64/en-US/firefox-30.0.tar.bz2
      install
      clean
  fi
fi