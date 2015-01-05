#!/bin/bash

old_IFS=$IFS

## Setando o carcatere de fim de linha como separador padrao do sistema ##
IFS='$'

if [ -z $1 ]; then
    echo "Por favor, passe o nome do arquivo como parametro."
    exit 1;
fi

## Iterando sobre cada linha do arquivo ##
for line in $(cat $1); do
    echo $line | grep ^"\s"*$ | sed "s/\t/*/g"
done

## Recuperando o separador padrao do sistema ##
IFS=$old_IFS
