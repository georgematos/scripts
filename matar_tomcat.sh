#!/bin/bash
PID=`fuser 8080/tcp`
if [ -z $PID ]
then
    echo "O Tomcat não está rodando!"
    exit 0
else
    echo "Matando o Tomcat! Numero do processo: $PID"
fi
kill -9 $PID
