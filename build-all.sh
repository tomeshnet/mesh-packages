#!/bin/bash
# crossbuild-essential-armhf libc6-dev:armhf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf

# Update debian repos
sudo apt-get update

# Install cross compilers
sudo apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf # ARM  Cross Compiler
sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu  # ARM64 Cross Compiler

# Install Go development environment
wget https://dl.google.com/go/go1.11.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.11.linux-arm64.tar.gz
rm -rf go1.11.linux-arm64.tar.gz
GOROOT=/usr/local/go

# Install Node.js
NODEJS_PREFIX=10
NODEJS_VERSION="$NODEJS_PREFIX.15.3"
curl -sL https://deb.nodesource.com/setup_$NODEJS_PREFIX.x | sudo -E bash -
sleep 1
sudo apt-get install -y nodejs

# Other build environment dependencies
sudo apt-get install -y python-dev libtool python-setuptools autoconf automake

# Define archetectures to compile for
ARCHS="i386 amd64 armhf arm64 all"
#ARCHS="armhf"

# Loop through all folders in packages/
cd packages
for PKG in b*/ ; do
    # Loop through all archetectures to cross compile to
    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        # Build package
        bash -x ./build.sh
        cd ..
    done
done
cd ..
