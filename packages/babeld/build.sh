#!/bin/bash

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
  ;;
  i386)
    PKG_ARCH="386"
  ;;
  armhf)
    PKG_ARCH="arm";
    args="CC=arm-linux-gnueabihf-gcc"
  ;;
  arm64)
    PKG_ARCH="arm64";
    args="CC=aarch64-linux-gnu-gcc"
  ;;
  *)
    exit 0
  ;;
esac

# Prep working directory
mkdir root
mkdir tmp
root=$(pwd)

# Prepare root directory
cp -R files/* root/
chmod 755 root/DEBIAN/postinst

git clone git://github.com/jech/babeld.git tmp
cd tmp
sed -i "s|PREFIX = /usr/local|PREFIX = $root/root/|" Makefile
make $args
make install $args 
cd ..

rm -rf tmp

# Make deb pacakges
if [ -f "../version.txt" ]; then
    version="$(cat ../version.txt)"
else
    version="$(root/bin/babeld -V  2>&1)"
    version=${version:7}
    echo $version > ../version.txt
fi

echo "Version: $version" >> root/DEBIAN/control
#echo "Architecture: $( dpkg --print-architecture)" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

sudo chown -R root.root root
dpkg-deb --build root
sudo rm -rf root
mv root.deb ../babeld-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
