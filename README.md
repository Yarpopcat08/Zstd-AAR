# Natives AAR builder

This repo hosts a simple builder of some native libraries for Android. Most of them are required for Minecraft mods and used in conjuction with the [NativesPlugin](https://github.com/MojoLauncher/NativesPlugin/) in MojoLauncher.  
Currently supported libraries are:
* zstd-jni (+ a patch to build it for DistantHorizons)
* lame4j-svc
* opus4j-svc
* rnnoise4j-svc
* speex4j-svc

## Getting the AAR

You can get the AAR files via three methods:

1. **Releases:** Download the latest AAR files from [releases](https://github.com/Yarpopcat08/Zstd-AAR/releases).
2. **Nightly.link:** Download the latest pre-built AAR files directly from [nightly.link](https://nightly.link/Yarpopcat08/Zstd-AAR/workflows/build/master/libraries-release.zip) without needing a GitHub account.
3. **Automated builds:** Download the latest AAR files from [GitHub Actions](https://github.com/Yarpopcat08/Zstd-AAR/actions/), however you will need a GitHub account to download them. 

## Building

To build the AARs yourself it is recommended to fork this repo and enable CI workflows.
To build an AAR with vanilla libraries locally you can simply clone the repo with submodules and run `./gradlew :app:assembleRelease`. If you wish to build patched libraries locally you may look at what `.github/workflows/build.yml` does.

# Credits

This builder uses the libraries directly through submodules, so if you need to check their license, just navigate to the `app/src/main` directory.

