#!/bin/bash

if [ -e /usr/bin/git-atualizar-enviar-branch ];
then
    BRANCH=`git rev-parse --abbrev-ref HEAD`

    git pull --rebase github homologacao
    git push github $BRANCH
else
    DIRETORIO_ATUAL=`pwd`
    NOME_SCRIPT="git-atualizar-enviar-branch.sh"
    CAMINHO_DO_ARQUIVO=$DIRETORIO_ATUAL/$NOME_SCRIPT
    echo "Instalando.."
    sudo ln -s $CAMINHO_DO_ARQUIVO /usr/bin/git-atualizar-enviar-branch
    source /home/$USER/.bashrc
    echo "Pronto! Para garantir o funcionamento reinicie o temrinal ;)"
fi


