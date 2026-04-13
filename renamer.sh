#!/bin/bash
# Adjustments for distant horizons mod, overwrites files, should ONLY be run in workflows!!!

CMAKE_FILE="./app/src/main/zstd/CMakeLists.txt"
if [ -f "$CMAKE_FILE" ]; then
    sed -i.bak 's/zstd-jni-/zstd-jni_dh-/g' "$CMAKE_FILE"
    echo "Updated $CMAKE_FILE"
else
    echo "File $CMAKE_FILE not found."
fi

SRC_DIR="./app/src/main/zstd/src/main/native"
if [ -d "$SRC_DIR" ]; then
    # find all files in the directory
    find "$SRC_DIR" -type f | while read -r file; do
        # use sed to replace both patterns
        sed -i.bak -e 's/com_github_luben/dhcomgithubluben/g' \
                   -e 's|com/github/luben|dhcomgithubluben|g' "$file"
        echo "Updated $file"
    done
else
    echo "Directory $SRC_DIR not found."
fi
