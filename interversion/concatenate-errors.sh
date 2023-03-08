#!/bin/bash

rm -rf output.txt
for file in /tmp/r4r5/*.txt
do
  content=$(cat "$file" | awk '{printf "%s\\\\n", $0}')
  count=${#content}
  if [ "$count" -gt 50000 ]; then
    echo "Too many characters to fit in a cell (50k limit)" >> output.txt
  else
    echo -e "$content" >> output.txt
  fi
done
