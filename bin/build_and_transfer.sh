#!/bin/bash

usage() {
  echo "usage: makev2 [<ip> <port>]"
  echo "       makev2 [<ip:port>]"
}
if [ $# -lt 0 ] || [ $# -gt 2 ]; then usage; fi

if [ $# -ne 0 ]; then
  if [[ "$1" =~ ":" ]];
  then
    case "${1}" in
    *:*) host=`echo $1 | sed -e 's/:.*//'`
         port=`echo $1 | sed -e 's/.*://'`
    ;;
    *) usage ;;
    esac

  else
    host=$1
    port=$2
  fi

  if [ -z $port ]; then
    port=22
  fi
  echo host=$host
  echo port=$port
else
  echo "Doing local installation only"
fi

#Build commands here

if [ ! -z $host ]; then
  cd /path/to/files || exit 1
  ssh -p $port root@$host "rm -rf /root/files >/dev/null 2>&1" || exit 1
  tar czvf - files | ssh -p $port root@$host tar -xzf - -C /root/ || exit 1
fi
