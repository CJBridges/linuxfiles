#!/bin/bash

for NAME in `find . -name pom.xml`; do
    sed -i 's?^\s*$?<value>PLACEHOLDERASDFASDF</value>?g' $NAME  || exit 1
    formatxml $NAME || exit 1
    sed -i 's?.*<value>PLACEHOLDERASDFASDF</value>.*$??g' $NAME || exit 1
done;
