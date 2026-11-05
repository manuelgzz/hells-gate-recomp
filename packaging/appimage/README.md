# Dante's Inferno ARM64 AppImage

The AppImage contains the native launcher, recompiled game executable,
ReXGlue runtime/GPU libraries, Qt 6 and an ARM64 `extract-xiso`. It never
contains copyrighted game files.

## Build dependencies

- AArch64 Linux host
- CMake 3.25+, Clang and Qt 6.4 development packages
- `linuxdeploy`, `linuxdeploy-plugin-qt` and `appimagetool` for AArch64
- Git and an internet connection for the pinned `extract-xiso` source

Build the game and launcher:

```bash
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DREXSDK_DIR=/path/to/rexglue-sdk \
  -DDANTESINFERNO_BUILD_LAUNCHER=ON
cmake --build build --parallel --target \
  dantes_inferno dantes_inferno_launcher
```

Create the AppImage:

```bash
LINUXDEPLOY=/path/to/linuxdeploy-aarch64.AppImage \
APPIMAGETOOL=/path/to/appimagetool-aarch64.AppImage \
PATH="/path/to/linuxdeploy-plugin-qt:$PATH" \
packaging/appimage/build-appimage-arm64.sh
```

Artifact: `build/DantesInferno-aarch64.AppImage`.

Override `DANTES_BIN`, `LAUNCHER_BIN`, `RUNTIME_LIB`, `GPU_LIB` or
`EXTRACT_XISO_BIN` if the artifacts are in other locations.

## x86-64

`build-appimage.sh` detects the host architecture; `build-appimage-x86_64.sh`
forces x86-64. Use the x86_64 builds of the tools and run it on an x86-64
host:

```bash
LINUXDEPLOY=/path/to/linuxdeploy-x86_64.AppImage \
APPIMAGETOOL=/path/to/appimagetool-x86_64.AppImage \
PATH="/path/to/linuxdeploy-plugin-qt:$PATH" \
packaging/appimage/build-appimage-x86_64.sh
```

Artifact: `build/DantesInferno-x86_64.AppImage`. `build-appimage-arm64.sh`
is the equivalent for AArch64 (artifact `DantesInferno-aarch64.AppImage`).

The recompiled `dantes_inferno` binary is generated from your own
`game/default.xex`, so it cannot be built in CI. Build it first following the
Linux steps in the main README (it ends up in `out/build/linux-release/`), then
point the script at the artifacts:

```bash
DANTES_BIN=out/build/linux-release/dantes_inferno \
RUNTIME_LIB=out/build/linux-release/librexruntime.so \
GPU_LIB=out/build/linux-release/librexgpu-xenos.so \
BUILD_DIR=out/build \
LAUNCHER_BIN=/path/to/dantes_inferno_launcher \
LINUXDEPLOY=/path/to/linuxdeploy-x86_64.AppImage \
APPIMAGETOOL=/path/to/appimagetool-x86_64.AppImage \
packaging/appimage/build-appimage-x86_64.sh
```

## Runtime

On first launch, choose a writable root folder. The launcher creates:

```text
root/
  game/       # Imported Xbox 360 files, including default.xex
  config/     # Launcher settings
  saves/
  cache/
  logs/
```

The game can be imported from an original Xbox 360 ISO or copied from an
already extracted directory containing `default.xex`.

If FUSE is unavailable:

```bash
APPIMAGE_EXTRACT_AND_RUN=1 ./DantesInferno-aarch64.AppImage
```

The host must provide a working Vulkan driver. Turnip/Mesa is intentionally
not bundled.
