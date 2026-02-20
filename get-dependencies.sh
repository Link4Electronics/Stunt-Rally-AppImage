#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    boost               \
    bullet              \
    cmake               \
    enet                \
    hicolor-icon-theme  \
    libdecor            \
    mygui               \
    ogre-next           \
    openal              \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package ogre-next2

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Stunt Rally..."
echo "---------------------------------------------------------------"
REPO="https://github.com/stuntrally/stuntrally3"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./stuntrally
echo "$VERSION" > ~/version

cd ./stuntrally
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
mv -v stuntrally3 ../../AppDir/bin
mv -v dist/stuntrally3.desktop ../../AppDir
