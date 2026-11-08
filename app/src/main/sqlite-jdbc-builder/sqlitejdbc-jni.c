#include <jni.h>

extern jint sqlitejdbc_org_onload(JavaVM *, void *);
extern void sqlitejdbc_org_onunload(JavaVM *, void *);
extern jint sqlitejdbc_dh_onload(JavaVM *, void *);
extern void sqlitejdbc_dh_onunload(JavaVM *, void *);

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved)
{
    JNIEnv *env = 0;
    jint result = JNI_ERR;

    if ((*vm)->GetEnv(vm, (void **)&env, JNI_VERSION_1_2) != JNI_OK)
        return JNI_ERR;

    // Check if both bindings are working correctly
    if (sqlitejdbc_org_onload(vm, reserved) == JNI_VERSION_1_2)
        result = JNI_VERSION_1_2;

    if ((*env)->ExceptionCheck(env))
        (*env)->ExceptionClear(env);

    if (sqlitejdbc_dh_onload(vm, reserved) == JNI_VERSION_1_2)
        result = JNI_VERSION_1_2;

    if ((*env)->ExceptionCheck(env))
        (*env)->ExceptionClear(env);

    return result;
}

JNIEXPORT void JNICALL JNI_OnUnload(JavaVM *vm, void *reserved)
{
    sqlitejdbc_org_onunload(vm, reserved);
    sqlitejdbc_dh_onunload(vm, reserved);
}
