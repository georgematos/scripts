#!/bin/bash

## Este script deve ser rodado a partir diretório raiz do projeto ./bin/db_update.sh

LAST_VERSION=`mvn initialize flyway:info | tail -9 | head -1 | cut -d " " -f 2`
LAST_CHANGES_SQL_FILE='./target/sql/hibernate3/last_changes.sql'
MIGRATION_SQL_DIR='./src/main/resources/db/migration/'

mvn hibernate3:hbm2ddl

echo "A utima versão do migration no seu ambiente é a" $LAST_VERSION

if [ $? == 0 ]
then
  if [ -f $LAST_CHANGES_SQL_FILE ]
  then

    cp $LAST_CHANGES_SQL_FILE $MIGRATION_SQL_DIR'last_changes.sql'

    if [ -f $MIGRATION_SQL_DIR'last_changes.sql' ]
    then
      echo "O arquivo last_changes.sql foi copiado com sucesso."
    else
      echo "Ocorreu um erro ao tentar copiar o arquivo last_changes.sql"
      exit 1
    fi

    echo -n "Próxima versão disponível: "
    read -e PROXIMA_VERSAO
    echo -n "Descricao: "
    read -e DESCRICAO
    DESCRICAO=`echo 'V'$PROXIMA_VERSAO'__'$DESCRICAO | sed "s/\./_/g"`'.sql'

    mv $MIGRATION_SQL_DIR'last_changes.sql' $MIGRATION_SQL_DIR$DESCRICAO

    if [ `mvn initialize flyway:info | tail -9 | head -1 | cut -d " " -f 2` == $PROXIMA_VERSAO ]
    then
      mvn initialize flyway:migrate
    else
      echo "Erro ao realizar o migrate..."
      exit 1
    fi

  fi
else
  echo "ERRO"
fi
