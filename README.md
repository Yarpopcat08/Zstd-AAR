# Simple ZSTD AAR builder

This repo hosts a simple builder than builds [ZSTD-Jni](https://github.com/luben/zstd-jni/tree/master) for Android and generates dummy Android Archive files. It also applies a [Distant Horizons](https://gitlab.com/distant-horizons-team/distant-horizons) forwarder to be compatible with the mod, as well as keep compatability with everything else.
To download builds, you can go to [actions](https://github.com/Yarpopcat08/Zstd-AAR/actions/), however you will need a GitHub account to download from there. 

## Building

If you want to build it yourself, you can either fork the repository and enable workflows so it is built automaticaly, or you can clone the repo, move `dhjni` to `./app/src/main/zstd/src/main/native/`, run `git apply ./CMakeLists.patch` and build it by running `./gradlew :app:assembleRelease`

## Credits

[ZSTD-Jni](https://github.com/luben/zstd-jni/) - BSD-2-Clause License

[dhjni forwarder](https://github.com/AngelAuraMC/amethyst-prebuilt-libraries/tree/master/misc/zstd-jni/dhjni) by [alexytomi](https://github.com/alexytomi) - Unknown License
