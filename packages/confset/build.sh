#!/bin/bash

case "$ARCH" in
  all)
    PKG_ARCH="all"
  ;;
  *)
    exit 0
  ;;
esac

# Prep working directory
mkdir root
root=$(pwd)

# Prepare root directory
cp -R files/* root/

# define version number
version=0.0.1

# Make deb pacakges
echo "Version: $version" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

sudo chown -R root.root root
sudo chmod a+x root/usr/bin/*
sudo dpkg-deb --build root

rm -rf root
mv root.deb ../confset-$version-$ARCH.deb
