#:/bin/bash
tag=${tag:-'dev'}
rm -f tmpfile
for json in "rules/*.json" 
do 
 jq '.include[].target' $json | uniq >> tmpfile
done
while read p; do
  echo "$p:$tag" | tr -d '"'
done <tmpfile



