#include "sqlite3.c"
#include "extension-functions.c"

#if defined(__GNUC__)
__attribute__((constructor))
#endif
static void sqlite3_jdbc_auto_extension_init(void)
{
    sqlite3_auto_extension((void (*)(void))RegisterExtensionFunctions);
}
