#!/bin/bash

mvn clean install -DskipTests

./bin/run_tests.sh

mvn docgem-maven-plugin:document -Dtarget=target/bentham/manual -DchaptersXmlPath=target/test-classes/chapters.xml -DpackagePrefix=com.quantaconsultoria.test.functional -DactionsFile=target/bentham/manual/action.csv

zenity --info --text "Rotina Temporária Concluída"
mpg123 ~/Sounds/desk_bell.mp3
