#!/bin/bash

# Install dependencies
sudo apt install build-essential pkg-config git zlib1g-dev tar automake autoconf libtool make g++

dir=$(pwd)

# Build GPAC
git clone https://github.com/gpac/gpac.git && cd gpac

latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

git checkout $latest_tag

./configure --static-bin

make -j $(nproc)

mv bin/gcc/MP4Box bin/gcc/mp4box

tar -czvf mp4box-$latest_tag-linux-amd64.tar.gz bin/gcc/mp4box
cd $dir

#Build Media Info

git clone https://github.com/MediaArea/MediaInfo.git && cd MediaInfo
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $latest_tag
cd MediaInfo/Project/GNU/CLI
./autogen.sh
./configure --enable-staticlibs
make -j $(nproc)
tar -czvf mediainfo-$latest_tag-linux-amd64.tar.gz mediainfo
cd $dir
