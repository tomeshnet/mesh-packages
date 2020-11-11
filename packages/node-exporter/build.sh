#!/bin/bash

NODEEXPORTER_VERSION="1.0.1"

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
    ARCH="amd64"
  ;;
  i386)
    PKG_ARCH="386"
    ARCH="386"
  ;;
  armhf)
    PKG_ARCH="arm";
    ARCH="armv7";
  ;;
  arm64)
    PKG_ARCH="arm64";
    ARCH="arm64";
  ;;
  *)
    exit 0
  ;;
esac

mkdir tmp
wget https://github.com/prometheus/node_exporter/releases/download/v$NODEEXPORTER_VERSION/node_exporter-$NODEEXPORTER_VERSION.linux-$ARCH.tar.gz -O "tmp/node-exporter.tar.gz"

mkdir root
mkdir root/opt
mkdir root/opt/node-exporter
cp -R files/* root/
tar xvfz "tmp/node-exporter.tar.gz" -C "root/opt/node-exporter" --strip 1
rm -rf root/opt/node-exporter/LICENSE
rm -rf root/opt/node-exporter/NOTICE

echo "Version: $NODEEXPORTER_VERSION" >> root/DEBIAN/control
#echo "Architecture: $( dpkg --print-architecture)" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

chmod 755 root/DEBIAN/postinst
sudo chown -R root.root root
dpkg-deb --build root
sudo rm -rf root
mv root.deb ../node-exporter-$NODEEXPORTER_VERSION-$ARCH.deb

# Install and cleanup
rm -rf tmp
