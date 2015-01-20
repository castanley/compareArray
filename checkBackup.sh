#!/bin/ksh
clear
FILE="backup_diff"

if [ -e $FILE ]; then
   rm $FILE
fi

echo "-----------------------------------------------"
echo "Initializing Arrays..."

set -A dfArray $(df | awk '{print $7}' | grep -v Mounted)
set -A dsmArray $(cat dsm.sys | grep DOMAIN | awk '{ s=""; for (i = 2; i <= NF; i++) s = s $i " "; print s }')

echo "Checking the difference between both arrays..."

for a in "${dfArray[@]}"; do
  in=false
  for b in "${dsmArray[@]}"; do
    if [[ $a == $b ]]; then
      #echo "$a is in dsm.sys"
      in=true
      break
    fi
  done
  $in || echo "   |- $a is not in dsm.sys"
  $in || echo $a >> backup_diff
done
echo "\nSaved difference to 'backup_diff'..."
echo "-----------------------------------------------"
