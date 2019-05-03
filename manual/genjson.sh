#!/bin/bash

IFS='|'

(
  printf "[\n"
  start=0
  cat complete.txt \
  | while read num title desc loc cnty extra ; do
    if [ "$start" -eq 1 ] ; then printf ",\n" ; fi
    start=1
    printf "\r%s" "$num" >&2

    num_a=`echo "$num"   | sed "s/^\([0-9][0-9][0-9][0-9]\)-\([0-9]\)/\1/g;;s/^0*//g"`
    num_b=`echo "$num"   | sed "s/^\([0-9][0-9][0-9][0-9]\)-\([0-9]\)/\2/g"`
    title=`echo "$title" | sed "s/\"/\o134\o134\o134\o042/g"`
    desc=` echo "$desc"  | sed "s/\"/\o134\o134\o134\o042/g"`
    loc=`  echo "$loc"   | sed "s/\"/\o134\o134\o134\o042/g"`
    nps=`  echo "$loc"   | sed "s/^.*, *\(NPS.*\)$/\1/g" | egrep "^NPS"`
    usgs=` echo "$loc"   | sed "s/^.*, *USGS Quadrangle Sheet Name: *\(.*\)$/\1/g" | egrep "^USGS"`
    loc=`  echo "$loc"   | sed "s/^Location: *//g;;s/, USGS Quadrangle Sheet Name: .*$//g;;s/, NPS-.*$//g"`

    printf "{\n"
    printf "\"id\"                :   %d  ,\n" "$num_a"
    printf "\"id_sub=\"           :   %d  ,\n" "$num_b"
    printf "\"id_str\"            : \"%s\",\n" "$num"
    printf "\"title\"             : \"%s\",\n" "$title"
    printf "\"description\"       : \"%s\",\n" "$desc"
    printf "\"location\"          : \"%s\",\n" "$loc"
    printf "\"site_lat\"          : \"%s\",\n" ""
    printf "\"site_lon\"          : \"%s\",\n" ""
    printf "\"site_ll_method\"    : \"%s\",\n" ""
    printf "\"plaque_lat\"        : \"%s\",\n" ""
    printf "\"plaque_lon\"        : \"%s\",\n" ""
    printf "\"plaque_ll_method\"  : \"%s\",\n" ""
    printf "\"access_lat\"        : \"%s\",\n" ""
    printf "\"access_lon\"        : \"%s\",\n" ""
    printf "\"access_ll_method\"  : \"%s\",\n" ""
    printf "\"notes\"             : \"%s\",\n" ""
    printf "\"data\"              : {    },\n"
    printf "\"image_links\"       : [    ],\n"
    printf "\"plaque_image_link\" : \"%s\",\n" ""
    printf "\"usgs_quad\"         : \"%s\",\n" "$usgs"
    printf "\"nps_id\"            : \"%s\",\n" "$nps"
    printf "\"county\"            : \"%s\" \n" "$cnty"
    printf "}\n"

  done
  printf "]\n"
) > temp.json
printf "\n" >&2
cat temp.json | jq . > complete.json
