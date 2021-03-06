#/bin/bash

VERSION="0.4"

executar() {

  if [ "$SERVIDOR" = "producao" ]
  then
    dumpProducao

    echo "Dropando Schema"
    psql -U postgres -d bentham -c "DROP SCHEMA public CASCADE"; sleep 2

    echo "Criando Schema"
    psql -U postgres -d bentham -c "CREATE SCHEMA public"; sleep 2

    echo "Importando base para o banco local"
    psql -h localhost -p 5432 -U postgres bentham < $BASE"_"$DATA.backup
  else
    dumpHomologacao

    echo "Dropando Schema"
    psql -U postgres -d bentham -c "DROP SCHEMA public CASCADE"; sleep 2

    echo "Criando Schema"
    psql -U postgres -d bentham -c "CREATE SCHEMA public"; sleep 2

    echo "Importando base para o banco local"
    psql -h localhost -p 5432 -U postgres bentham < "homologacao_"$BASE"_"$DATA.backup
  fi

  organizar
}

organizar() {
  if [ -d $BASE ]; then
    if [ "$SERVIDOR" = "homologacao" ]; then
      mv "homologacao_"$BASE"_"$DATA.backup $BASE
    else
      mv $BASE"_"$DATA.backup $BASE
    fi
  else
    mkdir $BASE
    if [ "$SERVIDOR" = "homologacao" ]; then
      mv "homologacao_"$BASE"_"$DATA.backup $BASE
    else
      mv $BASE"_"$DATA.backup $BASE
    fi
  fi
}

dumpProducao() {
  DATA=`date +%Y%m%d_%Hh%Mm`

  COMANDO_DUMP=`echo "sudo pg_dump -U postgres -W -h localhost $BASE > ~/$BASE/backup/$BASE""_""$DATA.backup"`

  echo "Criando o dump do banco no servidor"
  ssh ubuntu@quantaconsultoria.com $COMANDO_DUMP

  echo "Baixando o dump para o localhost"
  scp ubuntu@quantaconsultoria.com:/home/ubuntu/$BASE/backup/$BASE"_"$DATA.backup .
}

dumpHomologacao() {
  DATA=`date +%Y%m%d_%Hh%Mm`

  COMANDO_DUMP=`echo "sudo pg_dump -U postgres -W -h localhost "homologacao_"$BASE > ~/$BASE/"homologacao_"$BASE""_""$DATA.backup"`

  echo "Criando o dump do banco no servidor"
  ssh ubuntu@homologacao.quantaconsultoria.com $COMANDO_DUMP

  echo "Baixando o dump para o localhost"
  scp ubuntu@homologacao.quantaconsultoria.com:/home/ubuntu/$BASE/"homologacao_"$BASE"_"$DATA.backup .
}

dump_local() {
  echo -n "Qual é a base atual? (preurbis/seeljerj/prodoeste/cidades) "
  read BASE
  DATA=`date +%Y%m%d_%Hh%Mm`
  COMANDO_DUMP=`echo "sudo pg_dump -U postgres -W -h localhost bentham -f $BASE""_""$DATA.backup_local"`

  $COMANDO_DUMP
}

init() {
  echo -n "Digite a base de sua preferencia (preurbis/seeljerj/prodoeste/cidades) "
  read BASE

  ssh ubuntu@quantaconsultoria.com test -d /home/ubuntu/$BASE
}

importar() {
  DATA=`date +%Y%m%d_%Hh%Mm`

  echo "\033[01;37mDropando Schema\033[01;37m"
  psql -U postgres -d bentham -c "DROP SCHEMA public CASCADE"; sleep 2

  echo "\033[01;37mCriando Schema\033[01;37m"
  psql -U postgres -d bentham -c "CREATE SCHEMA public"; sleep 2

  echo "\033[01;32mImportando $1 para o banco local\033[01;32m"
  psql -h localhost -p 5432 -U postgres bentham < $1
}

help() {
  echo "

  -== Antes de utilizar ==-

  Antes de executar esse Script faça as seguintes alterações no arquivo
  /etc/postgresql/<versao>/main/pg_hba.conf para o usuario postgres:

  local   all         postgres                          md5

  Reinicie o serviço /etc/init.d/postgresql restart

  -== Opções ==-

   nenhum arg.  Baixa uma versão atualizada da base e importa automaticamente
   -install                       Instala o Script (em desenvolvimento)
   -d,                            Apenas cria e baixa o dump da base escolhida
   -i <dump>,                     Importa um dump já existente
   -l,                            Cria dump da base local
   -r <dump> <servidor remoto>,   Envia um dump existente para um servidor remoto e importa-o (em desenvolvimento)
   -t,                            Baixa a base do cliente escolhido do servidor de produção e importa no servidor de homologacao. (em desenvolvimento)
   -h,                            Exibe a ajuda

  "
  exit 0
}

uploadToHomologacao() {

  USER=`echo $REMOTESERV | cut -d "@" -f 1`
  DUMP=`echo $FILEDUMP | cut -d "/" -f 2`
  BASE=`echo $DUMP | cut -d "_" -f 1`

  scp $FILEDUMP $REMOTESERV:/home/$USER/
  ssh $REMOTESERV test -e /home/$USER/$DUMP
  if [ $? -eq 0 ]; then

    echo "Arquivo existe"

    echo "\033[01;37mDropando Schema no Servidor de homologacao\033[01;37m"
    COMANDO_DROP=`echo "psql -U postgres -d homologacao_$BASE -c "DROP SCHEMA public CASCADE"; sleep 2"`
    ssh $REMOTESERV $COMANDO_DROP

    echo "\033[01;37mCriando Schema no Servidor de homologacao\033[01;37m"
    COMANDO_CREATE=`echo "psql -U postgres -d homologacao_$BASE -c "CREATE SCHEMA public"; sleep 2"`
    ssh $REMOTESERV $COMANDO_CREATE

    echo "\033[01;32mImportando $DUMP para o banco no Servidor de homologacao\033[01;32m"
    COMANDO_IMPORT=`echo "psql -h localhost -p 5432 -U homologacao_$BASE bentham < $DUMP"`
    ssh $REMOTESERV $COMANDO_IMPORT
  else

    echo "\033[01;31mO arquivo de dump não foi encontrado no servidor, por favor verifique.\033[01;31m"

  fi
}

serverSelect() {

  echo "Escolha um servidor
  1 - producao
  2 - homologacao \n"
  read opcao

  SERVIDOR=""
  echo $SERVIDOR

  if [ $opcao -eq 1 ]; then
    SERVIDOR='producao'
  elif [ $opcao -eq 2 ]; then
    SERVIDOR='homologacao'
  else
    echo "\033[01;31mEscolha uma opção válida.\033[01;31m"
    exit 1
  fi

}

#==================================================
#                      Main                       #
#==================================================
clear

if [ "$1" = "-h" ]; then
  help
fi

if [ "$1" = "-install" ]; then
  echo "Instalando..."
  if [ -e /usr/bin/bentham_db_swap-*.sh ]; then
    read -p "Já existe uma versão instalada, deseja sobrescrever? (N/s) " OPTION
    OPTION=${OPTION:-N}
    if [ $OPTION = "S" -o $OPTION = "s" ]; then
      sudo cp ./bentham_db_swap-$VERSION.sh /usr/bin
      echo "Bentham DB Swap instalado com êxito."
    fi
  else
    sudo cp ./bentham_db_swap-$VERSION.sh /usr/bin
    echo "Bentham DB Swap instalado com êxito."
  fi
  exit 0
fi

if [ "$1" = "-r" ]; then
  FILEDUMP=$2
  REMOTESERV=$3
  uploadToHomologacao $FILEDUMP $REMOTESERV
  exit 0
fi

if [ "$1" = "-t" ]; then
  init
  dumpProducao
  organizar

  echo "uploadToHomologacao $BASE/"$BASE""_""$DATA".backup ubuntu@homologacao.quantaconsultoria.com"
  exit 0
fi

if [ "$1" = "-i" ]; then
  if [ -n "$2" ] && [ -e "$2" ]; then
    importar $2
    exit 0
  else
    echo "\033[01;31mPor favor passe um nome de arquivo válido como argumento.\033[01;31m"
    exit 1
  fi
fi

if [ "$1" = "-l" ]; then
  dump_local
  if [ $? -eq 0 ]; then
    echo "\033[01;32mDump local criado com sucesso\033[01;32m"
    exit 0
  else
    echo "\033[01;31mOcorreu um erro ao criar o dump local\033[01;31m"
    exit 1
  fi
fi

if [ "$1" = "-d" ]; then
  serverSelect
  init
  if [ $? -eq 0 ]; then
    if [ "$SERVIDOR" = "producao" ]; then
      dumpProducao
    else
      dumpHomologacao
    fi
    organizar
    exit 0
  fi
else
  serverSelect
  init
  if [ $? -eq 0 ]; then
    executar
    exit 0
  else
    echo "\033[01;31mO diretório escolhido não existe, por favor, escolha um dos apresentados na lista.\033[01;31m"
    exit 1
  fi
fi
