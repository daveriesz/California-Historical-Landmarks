#!/bin/bash

baseurl="http://ohp.parks.ca.gov/"
rooturl="${baseurl}?page_id=21387"

pagedir=pages
mkdir -p "$pagedir"

pageno()
{
  echo "$1" | sed "s/^.*?page_id=\([0-9][0-9]*\)$/\1/g"
}

pagefile()
{
  echo ${pagedir}/`pageno "$1"`.html
}

getpage()
{
  url="$1"
  pf=`pagefile "$url"`
  if [ ! -f "$pf" ] ; then
    echo "fetching $url >> $pf"
    curl -s "$url" | tr -d "\015" > "$pf"
  fi
}

getpage "$rooturl"
cat `pagefile "$url"` \
| tr "<" "\n" \
| egrep -i "a +href" \
| egrep "linktype=\"page\" data=" \
| sed "s/A href=\"\([^\"][^\"]*\)\"[^>]*>\(.*\)$/\1 \2/g" \
| while read aa bb ; do
  countyurl="${baseurl}${aa}"
  getpage "$countyurl"
  pf=`pagefile "$url"`

  county=`cat "$pf" | egrep "<title>" | sed "s/^.*<title>\([^<]*\)<\/title>.*$/\1/g"`
#  echo $county

  cat "$pf" \
  | sed "s/ Miles Mahan began/ - Miles Mahan began/g" \
  | sed "s/\(COURTHOUSE\)<\/strong> \(This\)/\1 - \2/g" \
  | sed "s/\(NURSERY\)<\/strong> \(In\)/\1 - \2/g" \
  | sed "s/\(BIG BAR\)<\/STRONG> \(The Mokelumne\)/\1 - \2/g" \
  | sed "s/PLAYA<\/STRONG> From/PLAYA - From/g" \
  | sed "s/\(Station\) <\/STRONG>-\(In 1989\)/\1 - \2/g" \
  | sed "s/NO\. 56O/NO\. 560/g" \
  | sed "s/NO\. 1O3/NO\. 103/g" \
  | sed "s/NO\. 3O3/NO\. 303/g" \
  | sed "s/Loc<STRONG>ation/Location/g" \
  | sed "s/Location<\/STRONG> 88/Location: 88/g" \
  | sed "s/–/-/g" \
  | sed "s/> *N[O0o]\. *\([0-9]\)/>NO\. \1/g" \
  | sed "s/>\(NO\. [0-9]\)/>\n\1/g" \
  | egrep "^NO\. [0-9]" \
  | sed "s/<[^>]*>/ /g" \
  | sed "s/\&nbsp;/ /g" \
  | sed "s/   */ /g" \
  | sed "s/\&ldquo;/\"/g;;s/\&rdquo;/\"/g" \
  | sed "s/\&lsquo;/\'/g;;s/\&rsquo;/\'/g" \
  | sed "s/\&ndash;/--/g" \
  | sed "s/  *Location *: */|/g" \
  | sed "s/ *$/|${county}/g" \
  | sed "s/^NO. \([0-9][0-9\-]*\)\.* \(.*\) - /\1|\2|/g" \
  | sed "s/^\(600|H.*|\)\(Sacramento\)$/\1\|\2/g" \
  | sed "s/^\([0-9][^0-9]\)/000\1/g" \
  | sed "s/^\([0-9][0-9][^0-9]\)/00\1/g" \
  | sed "s/^\([0-9][0-9][0-9][^0-9]\)/0\1/g" \

#  exit 0
done \
| sort


