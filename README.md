# Simple ZSTD AAR builder

This repo hosts a simple builder that builds [ZSTD-Jni](https://github.com/luben/zstd-jni/tree/master) for Android and generates dummy Android Archive files. It also builds a [Distant Horizons](https://gitlab.com/distant-horizons-team/distant-horizons) mod-specific patched ZSTD version.

To download builds, you can go to [actions](https://github.com/Yarpopcat08/Zstd-AAR/actions/), however you will need a GitHub account to download from there. 

## Building

To build the AARs yourself it is recommended to fork this repo and enable CI workflows.
To build an AAR with vanilla ZSTD locally you can simply clone the repo and run `./gradlew :app:assembleRelease`. If you wish to build ZSTD for DH locally you may look at what `.github/workflows/build.yml` does.

## Credits

[ZSTD-Jni](https://github.com/luben/zstd-jni/) - BSD-2-Clause License

