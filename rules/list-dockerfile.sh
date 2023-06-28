#:/bin/bash

for json in "*.json" 
do 
 jq '.include[].dockerfile' $json | uniq 
done

