#!/bin/bash

die() {
  echo ${*}
  exit 1
}

if [ $# != 1 ]; then
  echo "Specify directory as second argument"
  exit 1
fi

cd $1 || die "Couldn't get to directory"
for i in `find . -name \*rpm`; do
  mv $i $(rpm -qp $i).rpm || die "Failed to rename rpm"
done
