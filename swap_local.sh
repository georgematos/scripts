#/bin/bash

## Antes de executar esse Script faça as seguintes alterações no arquivo /etc/postgresql/<versao>/main/pg_hba.conf para o usuario postgres:
## local   all         postgres                          md5
## Reinicie o serviço /etc/init.d/postgresql restart

executar() {
  DATA=`date +%Y%m%d_%Hh%Mm`

  echo "\033[01;37mDropando Schema\033[01;37m"
  psql -U postgres -d bentham -c "DROP SCHEMA public CASCADE"; sleep 2

  echo "\033[01;37mCriando Schema\033[01;37m"
  psql -U postgres -d bentham -c "CREATE SCHEMA public"; sleep 2

  echo "\033[01;32mImportando $1 para o banco local\033[01;32m"
  psql -h localhost -p 5432 -U postgres bentham < $1
}

# Verifica se foi passado algum parametro
if [ $# -eq 0 ]
then
  echo "\033[01;31mPasse o nome do arquivo de dump.\033[01;31m"
  exit 1;
fi

# Verifica se o arquivo não existe
if [ -e $1 ]
then

  executar $1

else

  echo "\033[01;31mO arquivo não existe...\033[01;31m"

fi
