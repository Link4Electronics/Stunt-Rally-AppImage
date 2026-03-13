#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libdecor
#    bullet              \
#    enet                \
#    libdecor            \
#    mygui               \
#    ogre-next           \
#    openal              \
#    python              \
#    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano #! llvm

# Comment this out if you need an AUR package
#make-aur-package boost174-libs

# If the application needs to be manually built that has to be done down here
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    echo "Making nightly build of Stunt Rally..."
    echo "---------------------------------------------------------------"
    REPO="https://github.com/stuntrally/stuntrally3"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone "$REPO" ./stuntrally
    echo "$VERSION" > ~/version

    mkdir -p ./AppDir/bin
    cd ./stuntrally
    python3 build-sr3-Linux.py
    mkdir -p build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    make -j$(nproc)
    mv -v stuntrally3 ../../AppDir/bin
    mv -v dist/stuntrally3.desktop ../../AppDir
else
    mkdir -p ./AppDir/bin
    wget https://netactuate.dl.sourceforge.net/project/stuntrally/3.3/StuntRally-3.3-Linux.txz
    bsdtar -xvf StuntRally-3.3-Linux.txz
    #mv -v StuntRally-3.3-Linux/* ./AppDir/bin
    cd StuntRally-3.3-Linux
    mv -v bin config data plugins.cfg ../AppDir/bin
    mv -v lib/* /usr/lib
fi
