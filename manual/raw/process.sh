#!/bin/bash

for x in *.txt ; do
  y=`echo $x | sed "s/\.txt//g"`
  cat "$x" \
  | sed "1,/^${y}$/d" \
  | sed '/^RELATED PAGES$/,$d' \
  | sed "s/^  *//g" \
  | sed "s/^Location[: ] */Location: /g" \
  | sed "s/^\(Listed\) in \(the National Register of Historic Places\)/\1 on \2/g" \
  | sed "s/^N[0o]\. */NO. /g" \
  | sed "s/^\(NO\)/}\1/g" \
  | sed "s/^\(Location.*\)$/{\1/g" \
  | sed "s/^\(Listed.*\)$/{\1/g" \
  | sed "s/^\(USGS.*\)$/{\1/g" \
  | sed "s/^\(Plaque.*\)$/{\1/g" \
  | ( tr -d "\n" && echo "" ) \
  | tr "}" "\n" \
  | sed "s/{/|/g" \
  | sed "/^ *$/d" \
  | sed "s/^NO. \([0-9][0-9\-]*\) /\1\|/g" \
  | sed "s/^\([0-9][^0-9]\)/000\1/g" \
  | sed "s/^\([0-9][0-9][^0-9]\)/00\1/g" \
  | sed "s/^\([0-9][0-9][0-9][^0-9]\)/0\1/g" \
  | sed "s/$/\|$y/g" \
  > "../$x"
done
