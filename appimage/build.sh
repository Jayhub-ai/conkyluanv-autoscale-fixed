#!/bin/bash

set -e
set -x

# building in temporary directory to keep system clean
# use RAM disk if possible (as in: not building on CI system like Travis, and RAM disk is available)
if [ "$CI" == "" ] && [ -d /dev/shm ]; then
    TEMP_BASE=/dev/shm
else
    TEMP_BASE=/tmp
fi

BUILD_DIR=$(mktemp -d -p "$TEMP_BASE" AppImageLauncher-build-XXXXXX)

# make sure to clean up build dir, even if errors occur
cleanup () {
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
}
trap cleanup EXIT

# store repo root as variable
REPO_ROOT=$(readlink -f $(dirname $(dirname $0)))
OLD_CWD=$(readlink -f .)

# check if we have a recent enough version of librsvg
if pkg-config --atleast-version 2.60 librsvg-2.0; then
  ENABLE_RSVG=ON
else
  ENABLE_RSVG=OFF
fi

# switch to build dir
pushd "$BUILD_DIR"

# Set compiler environment variables if not already set
if [ -z "$CC" ]; then
  if command -v clang >/dev/null 2>&1; then
    export CC=clang
  else
    export CC=gcc
  fi
fi

if [ -z "$CXX" ]; then
  if command -v clang++ >/dev/null 2>&1; then
    export CXX=clang++
  else
    export CXX=g++
  fi
fi

# configure build files with cmake
# we need to explicitly set the install prefix, as CMake's default is /usr/local for some reason...
cmake -G Ninja                         \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo    \
  -DRELEASE=$RELEASE                   \
  -DBUILD_AUDACIOUS=ON                 \
  -DBUILD_DOCS=ON                      \
  -DBUILD_HTTP=ON                      \
  -DBUILD_ICAL=ON                      \
  -DBUILD_ICONV=ON                     \
  -DBUILD_IRC=ON                       \
  -DBUILD_JOURNAL=ON                   \
  -DBUILD_LUA_CAIRO=ON                 \
  -DBUILD_LUA_IMLIB2=ON                \
  -DBUILD_LUA_RSVG=${ENABLE_RSVG}      \
  -DBUILD_MYSQL=ON                     \
  -DBUILD_NVIDIA=ON                    \
  -DBUILD_PULSEAUDIO=ON                \
  -DBUILD_RSS=ON                       \
  -DBUILD_CURL=ON                      \
  -DBUILD_WAYLAND=ON                   \
  -DBUILD_WLAN=ON                      \
  -DBUILD_X11=ON                       \
  -DBUILD_XMMS2=ON                     \
  -DCMAKE_C_COMPILER=$CC               \
  -DCMAKE_CXX_COMPILER=$CXX            \
  -DCMAKE_INSTALL_PREFIX=./AppDir/usr  \
  "$REPO_ROOT"

# build project and install files into AppDir
cmake --build .
cmake --install .

# Download and prepare AppImage tools
ARCH=$(uname -m)
wget -q "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${ARCH}.AppImage"

# make them executable
chmod +x linuxdeploy-${ARCH}.AppImage

# Create AppImage
./linuxdeploy-${ARCH}.AppImage \
  --appdir AppDir \
  -e AppDir/usr/bin/conky \
  -i AppDir/usr/share/icons/hicolor/scalable/apps/conky-logomark-violet.svg \
  -d AppDir/usr/share/applications/conky.desktop

wget -q "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${ARCH}.AppImage"

chmod +x appimagetool-${ARCH}.AppImage

GPG_KEY=C793F1BA
if gpg --list-keys ${GPG_KEY} 2>/dev/null; then
  ./appimagetool-${ARCH}.AppImage AppDir --sign --sign-key ${GPG_KEY}
else
  ./appimagetool-${ARCH}.AppImage AppDir
fi

for f in conky*.AppImage
do
  sha256sum $f > $f.sha256
done

mv conky*.AppImage* "$OLD_CWD" || true

# gzip & copy the man page, which will be attached to releases
if [ -f doc/conky.1 ]; then
  gzip -c doc/conky.1 > "$OLD_CWD/conky.1.gz"
fi
