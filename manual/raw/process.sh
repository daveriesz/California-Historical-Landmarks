#!/bin/bash

for x in *.txt ; do
  y=`echo $x | sed "s/\.txt//g"`
  cat "$x" \
  | sed "1,/^${y}$/d" \
  | sed '/^RELATED PAGES$/,$d' \
  | sed "s/^  *//g" \
  | sed "s/^\(NO\)/}\1/g" \
  | sed "s/^\(Location.*\)$/{\1/g" \
  | ( tr -d "\n" && echo "" ) \
  | tr "}" "\n" \
  | sed "s/{/|/g" \
  | sed "/^ *$/d" \
  | sed "s/^NO. \([0-9][0-9\-]*\) /\1\|/g" \
  | sed "s/^\([0-9][^0-9]\)/000\1/g" \
  | sed "s/^\([0-9][0-9][^0-9]\)/00\1/g" \
  | sed "s/^\([0-9][0-9][0-9][^0-9]\)/0\1/g" \
  | sed "s/$/\|$y/g" \
  | sed "s/ - /|/g" \
  | sed "s/ *| */|/g" \
  | sed "s/\([^|]\) *\(Location:\)/\1|\2/g" \
  | sed "s/^\([0-9][0-9][0-9][0-9]\)|/\1-0|/g" \
  > "../$x"
  cat "../$x"
done | sort > ../complete.txt
