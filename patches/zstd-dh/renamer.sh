#!/bin/bash
# Adjustments for distant horizons mod, overwrites files, should ONLY be run in workflows!!!

SRC_DIR="./app/src/main/zstd/src/main/native"
if [ -d "$SRC_DIR" ]; then
    find "$SRC_DIR" -type f | while read -r file; do
        sed -i.bak -e 's/com_github_luben/dhcomgithubluben/g' \
                   -e 's|com/github/luben|dhcomgithubluben|g' "$file"
        echo "Updated $file"
    done
else
    echo "Directory $SRC_DIR not found."
fi
