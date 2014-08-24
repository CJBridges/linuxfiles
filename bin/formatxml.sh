#!/bin/sh
# This script reformats an xml file to use 2 spaces
# while preserving blank lines for readability
# Author: Eric Murray/CJ Bridges

if [ $# -lt 1 ]; then
  echo "Usage: $0 <file1> [file2]"
  echo "Example: find . -name pom.xml -exec $0 {} \;"
  exit 1
fi

# Use a 2 space indent here
export XMLLINT_INDENT="  "

format_file() {
  cp ${1} ${1}.bak || exit 1
  sed -i 's?^\s*$?<value>PLACEHOLDERASDFASDF</value>?g' ${1}
  errors=`xmllint --format ${1} | grep error 2>&1`
  if [ "${errors}" != "" ]
  then
    echo "errors for file ${1}"
    echo ${errors}
  else
    echo "no XML errors for file ${1}"
    xmllint --format --recover ${1} > ${1}.tmp && mv ${1}.tmp ${1}
  fi
  sed -i 's?.*<value>PLACEHOLDERASDFASDF</value>.*$??g' ${1}
  # delete the bak if the files are the same
  diff -q ${1} ${1}.bak >/dev/null 2>&1 && rm ${1}.bak
}

for i in "${*}"
do
  format_file $i
done
