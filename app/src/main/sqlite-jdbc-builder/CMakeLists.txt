# A complete mess of generated CMake script that downloads JDBC archive and extracts required files for building
# I mean, it's really cringe. Needs rewriting.

set(SQLITE_JDBC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../sqlite-jdbc")
set(SQLITE_JDBC_SRC "${SQLITE_JDBC_DIR}/src/main/java/org/sqlite/core")

# !!! A PART THAT NEEDS REWRITING: BEGIN !!!

file(STRINGS "${SQLITE_JDBC_DIR}/VERSION" SQLITE_VERSION_LINE)
string(REGEX REPLACE "^version=" "" SQLITE_VERSION "${SQLITE_VERSION_LINE}")

string(REPLACE "." ";" SQLITE_VERSION_PARTS "${SQLITE_VERSION}")
list(LENGTH SQLITE_VERSION_PARTS SQLITE_VERSION_COUNT)
set(SQLITE_AMALGAMATION_ID "")
set(_index 0)
foreach(_part IN LISTS SQLITE_VERSION_PARTS)
    if(_index GREATER 0)
        string(LENGTH "${_part}" _length)
        if(_length EQUAL 1)
            set(_part "0${_part}")
        endif()
    endif()
    string(APPEND SQLITE_AMALGAMATION_ID "${_part}")
    math(EXPR _index "${_index} + 1")
endforeach()
if(SQLITE_VERSION_COUNT LESS_EQUAL 3)
    string(APPEND SQLITE_AMALGAMATION_ID "00")
endif()

set(SQLITE_AMALGAMATION_NAME "sqlite-amalgamation-${SQLITE_AMALGAMATION_ID}")
set(SQLITE_AMALGAMATION_CACHE "${CMAKE_BINARY_DIR}/../sqlite-jdbc-amalgamation")
set(SQLITE_AMALGAMATION_DIR "${SQLITE_AMALGAMATION_CACHE}/${SQLITE_AMALGAMATION_NAME}")
set(SQLITE_AMALGAMATION_ZIP "${SQLITE_AMALGAMATION_CACHE}/${SQLITE_AMALGAMATION_NAME}.zip")

if(NOT EXISTS "${SQLITE_AMALGAMATION_DIR}/sqlite3.c")
    file(MAKE_DIRECTORY "${SQLITE_AMALGAMATION_CACHE}")
    file(LOCK "${SQLITE_AMALGAMATION_CACHE}/.lock" GUARD PROCESS TIMEOUT 600 RESULT_VARIABLE _lock_result)
    if(NOT _lock_result EQUAL 0)
        message(FATAL_ERROR "Failed to lock ${SQLITE_AMALGAMATION_CACHE}")
    endif()
    if(NOT EXISTS "${SQLITE_AMALGAMATION_DIR}/sqlite3.c")
        set(_downloaded FALSE)
        foreach(_year 2026 2025 2024 2023 2022 2021 2020)
            file(DOWNLOAD
                "https://www.sqlite.org/${_year}/${SQLITE_AMALGAMATION_NAME}.zip"
                "${SQLITE_AMALGAMATION_ZIP}"
                STATUS _download_status
                TLS_VERIFY ON)
            list(GET _download_status 0 _download_code)
            if(_download_code EQUAL 0)
                set(_downloaded TRUE)
                break()
            endif()
        endforeach()
        if(NOT _downloaded)
            file(REMOVE "${SQLITE_AMALGAMATION_ZIP}")
            message(FATAL_ERROR "Failed to download ${SQLITE_AMALGAMATION_NAME}.zip")
        endif()
        file(ARCHIVE_EXTRACT INPUT "${SQLITE_AMALGAMATION_ZIP}" DESTINATION "${SQLITE_AMALGAMATION_CACHE}")
    endif()
    file(LOCK "${SQLITE_AMALGAMATION_CACHE}/.lock" RELEASE)
endif()

# !!! A PART THAT NEEDS REWRITING: END !!!

file(READ "${SQLITE_JDBC_SRC}/NativeDB.c" NATIVE_DB_SOURCE)

set(NATIVE_DB_ORG_SRC "${CMAKE_CURRENT_BINARY_DIR}/NativeDB-org.c")
string(REPLACE "JNI_OnLoad" "sqlitejdbc_org_onload" NATIVE_DB_ORG_SOURCE "${NATIVE_DB_SOURCE}")
string(REPLACE "JNI_OnUnload" "sqlitejdbc_org_onunload" NATIVE_DB_ORG_SOURCE "${NATIVE_DB_ORG_SOURCE}")
file(WRITE "${NATIVE_DB_ORG_SRC}" "${NATIVE_DB_ORG_SOURCE}")

set(NATIVE_DB_DH_SRC "${CMAKE_CURRENT_BINARY_DIR}/NativeDB-dh-sqlite.c")
string(REPLACE "Java_org_sqlite_core_NativeDB" "Java_dh_1sqlite_core_NativeDB" NATIVE_DB_DH_SOURCE "${NATIVE_DB_SOURCE}")
string(REPLACE "\"org/sqlite/" "\"dh_sqlite/" NATIVE_DB_DH_SOURCE "${NATIVE_DB_DH_SOURCE}")
string(REPLACE "JNI_OnLoad" "sqlitejdbc_dh_onload" NATIVE_DB_DH_SOURCE "${NATIVE_DB_DH_SOURCE}")
string(REPLACE "JNI_OnUnload" "sqlitejdbc_dh_onunload" NATIVE_DB_DH_SOURCE "${NATIVE_DB_DH_SOURCE}")
file(WRITE "${NATIVE_DB_DH_SRC}" "${NATIVE_DB_DH_SOURCE}")

set(NATIVE_DB_DH_SYMBOLS
    xFunc
    xStep
    xInverse
    xValue
    xFinal
    xCompare
    busyHandlerCallBack
    change_busy_handler
    free_collation_func
    free_udf_func
    reportProgress
    updateProgress
    copyLoop
    update_hook
    commit_hook
    rollback_hook
    clear_commit_listener)
set(NATIVE_DB_DH_DEFINITIONS "")
foreach(_symbol IN LISTS NATIVE_DB_DH_SYMBOLS)
    list(APPEND NATIVE_DB_DH_DEFINITIONS "${_symbol}=sqlitejdbc_dh_${_symbol}")
endforeach()
set_source_files_properties("${NATIVE_DB_DH_SRC}" PROPERTIES COMPILE_DEFINITIONS "${NATIVE_DB_DH_DEFINITIONS}")

add_library(sqlitejdbc SHARED sqlite3-jdbc.c sqlitejdbc-jni.c "${NATIVE_DB_ORG_SRC}" "${NATIVE_DB_DH_SRC}")
target_include_directories(sqlitejdbc PRIVATE "${SQLITE_AMALGAMATION_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/include" "${SQLITE_JDBC_DIR}/src/main/ext")

# Go brrr. Extracted from the real:tm: build script
target_compile_definitions(sqlitejdbc PRIVATE
    SQLITE_ENABLE_LOAD_EXTENSION=1
    SQLITE_HAVE_ISNAN
    HAVE_USLEEP=1
    SQLITE_ENABLE_COLUMN_METADATA
    SQLITE_CORE
    SQLITE_ENABLE_FTS3
    SQLITE_ENABLE_FTS3_PARENTHESIS
    SQLITE_ENABLE_FTS5
    SQLITE_ENABLE_RTREE
    SQLITE_ENABLE_PERCENTILE
    SQLITE_ENABLE_STAT4
    SQLITE_ENABLE_DBSTAT_VTAB
    SQLITE_ENABLE_MATH_FUNCTIONS
    SQLITE_THREADSAFE=1
    SQLITE_DEFAULT_MEMSTATUS=0
    SQLITE_DEFAULT_FILE_PERMISSIONS=0666
    SQLITE_MAX_VARIABLE_NUMBER=250000
    SQLITE_MAX_MMAP_SIZE=1099511627776
    SQLITE_MAX_LENGTH=2147483647
    SQLITE_MAX_COLUMN=32767
    SQLITE_MAX_SQL_LENGTH=1073741824
    SQLITE_MAX_FUNCTION_ARG=127
    SQLITE_MAX_ATTACHED=125
    SQLITE_MAX_PAGE_COUNT=4294967294
    SQLITE_DISABLE_PAGECACHE_OVERFLOW_STATS)

target_compile_options(sqlitejdbc PRIVATE -Os -fvisibility=hidden -Wno-implicit-function-declaration)
target_link_options(sqlitejdbc PRIVATE -Wl,-soname,libsqlitejdbc.so)
target_link_libraries(sqlitejdbc log m dl)
