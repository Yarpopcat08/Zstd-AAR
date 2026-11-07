#!/bin/sh
set -eu

# A script to generate a NativeDB header. That's it.

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SQLITE_DIR="$SCRIPT_DIR/../sqlite-jdbc"
WORK_DIR="${TMPDIR:-/tmp}/sqlite-jdbc-native-header"
SLF4J_VERSION=1.7.36
SLF4J_JAR="$WORK_DIR/slf4j-api-$SLF4J_VERSION.jar"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR/classes" "$work_dir/include"

curl -fsSL -o "$SLF4J_JAR" \
    "https://repo1.maven.org/maven2/org/slf4j/slf4j-api/$SLF4J_VERSION/slf4j-api-$slf4j_version.jar"

javac -cp "$SLF4J_JAR" \
    -h "$WORK_DIR/include" \
    -sourcepath "$SQLITE_DIR/src/main/java" \
    -d "$WORK_DIR/classes" \
    "$SQLITE_DIR/src/main/java/org/sqlite/core/NativeDB.java"

cp "$WORK_DIR/include/org_sqlite_core_NativeDB.h" "$SCRIPT_DIR/include/NativeDB.h"
