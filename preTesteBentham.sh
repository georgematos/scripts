#!/bin/bash

# Realizando backup
cp /home/george/git/bentham/bin/run_tests.sh backTemp

scriptDeTestes='#!/bin/bash

i=0
files=()
CIRCLE_NODE_TOTAL=1
CIRCLE_NODE_INDEX=0
for file in $(find target/test-classes -name "*Test.class" | grep -v ConsultasSQLDBTest | sort)
do
  if [ $(($i % $CIRCLE_NODE_TOTAL)) -eq $CIRCLE_NODE_INDEX ]
  then
    file=${file/\.class/}
    file=${file/target\/test-classes\//}
    files+=",$file"
  fi
  ((i++))
done
files=${files#","}
mvn test -Dtest=ConsultasSQLDBTest -Dflyway.skip=true
DISPLAY=:1999 mvn cobertura:cobertura -Dtest="${files[@]}" -Dflyway.skip=true
returnCode=$?

exit $returnCode'

echo $scriptDeTestes > /home/george/Desenvolvimento/workspace/bentham/bin/run_tests.sh
