#!/bin/bash 

cat builds | while read line; 
do
  arr=(`echo $line | tr " " "\n"`)
  
if [ ${arr[1]} == "D" ]
then
  echo "Starting Daily Build for ${arr[0]}"
  curl http://localhost:8080/job/android/buildWithParameters?LUNCH=${arr[0]}
fi
if [ ${arr[1]} == "W" ] && [ $(date +%u) == "7" ]
then
  echo "Starting Weekly Build for ${arr[0]}"
  curl http://localhost:8080/job/android/buildWithParameters?LUNCH=${arr[0]}
fi
if [ ${arr[1]} == "M" ] && [ $(date +%d) == "1" ]
then
  echo "Starting Monthly Build for ${arr[0]}"
  curl http://localhost:8080/job/android/buildWithParameters?LUNCH=${arr[0]}
fi

done

