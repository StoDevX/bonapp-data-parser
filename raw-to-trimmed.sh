#!/bin/bash -e

cd data-raw
for file in ./*.txt; do
	OUTPUT="../data-trimmed/$file"
	tail -n +12 "$file" > "$OUTPUT"
done
