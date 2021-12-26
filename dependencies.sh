#!/bin/bash

echo "Updating system..."
sudo apt update

echo "Installing dependencies..."
sudo apt install -y postgresql postgis build-essential git golang libleveldb-dev \
                    libgeos-dev osmosis

echo "Starting postgresql service"
sudo sudo service postgresql start

if [ ! -f "/usr/bin/imposm" ]; then
  echo "Installing imposm"
  cd /tmp/
  wget https://github.com/omniscale/imposm3/archive/refs/tags/v0.11.1.tar.gz
  tar xf v0.11.1.tar.gz
  rm v0.11.1.tar.gz
  cd imposm3-0.11.1/
  make -j $(nproc)
  sudo cp imposm /usr/bin/
fi

echo "Done"