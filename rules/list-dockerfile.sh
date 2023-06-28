#:/bin/bash

for json in "rules/*.json" 
do 
 jq '.include[].dockerfile' $json | uniq 
done

