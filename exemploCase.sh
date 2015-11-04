#!/bin/bash
clear
while true
do
  echo "Escolha um servidor"
  echo "1 - Produção;"
  echo "2 - Homologação;"
  echo "3 - Limpar;"
  echo "4 - Sair;"
  echo ""
  read opcao

  case $opcao in

    1) echo "producao" ;;

    2) echo "homologacao" ;;

    3) clear ;;

    4) exit 0 ;;

    *) echo "Selecione uma opção" ;;

  esac
done