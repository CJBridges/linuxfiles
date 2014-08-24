#!/bin/bash
set -x

start_ntp_and_kill_after_delay() {
  FAIL=0
  echo "Starting ntp for step $1"
  start ntp &
  PID_OF_NTP=$!
  echo "Waiting for ntp to exit"
  for i in $(seq 1 15); do
    sleep 1
    kill -0 $PID_OF_NTP >/dev/null 2>&1 || break
    [ $i -eq 15 ] && FAIL=1 && break
  done
  if [ $FAIL -eq 1 ]; then
    echo "Failed at step $1"
    kill $PID_OF_NTP && sleep 2 && kill -9 $PID_OF_NTP
    killall ntpd 
  fi
}

TIMES_TO_RUN=$1
echo TIMES_TO_RUN=$TIMES_TO_RUN

for i in $(seq 1 $TIMES_TO_RUN); do
  echo ""
  echo ""
  echo "Presetup - clean everything to a good state - $i"
  node1date=`ssh root@node01 date`
  date --set="$node1date"
  hwclock -w
  date
  hwclock
  echo "End Pre-setup"

  echo "Plain test... sycning the clocks"
  stop ntp
  start_ntp_and_kill_after_delay PLAINTEST

  echo "Get the date out of sync"
  stop ntp
  date --set="Wed May 19 16:01:18 PDT 2014"
  date
  hwclock
  start_ntp_and_kill_after_delay DATEOUTOFSYNC

  echo "Get the date and hwclock out of sync"
  stop ntp
  date --set="Wed May 19 16:01:18 PDT 2014"
  hwclock -w
  date
  hwclock
  start_ntp_and_kill_after_delay DATEANDHWOUTOFSYNC

  #echo "Fixing clock for next clean test"
  #hwclock -w

  echo "hwclock out of sync, but date in sync"
  stop ntp
  date
  hwclock
  start_ntp_and_kill_after_delay HWOUTOFSYNCDATEOK

done

echo "Cleanup - set things back to normal"
node1date=`ssh root@node01 date`
date --set="$node1date"
hwclock -w
date
hwclock
echo "all done"
