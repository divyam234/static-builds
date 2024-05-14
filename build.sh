#!/bin/bash

# Install dependencies
sudo apt install build-essential pkg-config git zlib1g-dev tar automake autoconf libtool make g++

dir=$(pwd)

kernel=$(uname -s)

machine=$(uname -m)

platform=""

if [[ $kernel == "Linux" ]]; then
  if [[ $machine == "x86_64" ]]; then
    platform="linux-amd64"
  elif [[ $machine == "i686" ]]; then
    platform="linux-386"
  elif [[ $machine == "armv7l" ]]; then
    platform="linux-armv7"
  elif [[ $machine == "aarch64" ]]; then
    platform="linux-arm64"
  else
    platform="linux"
  fi
else
  platform="unknown"
fi

#Build GPAC

mkdir gpac_build 

cd gpac_build 

latest_tag=$(curl -s "https://api.github.com/repos/gpac/gpac/releases/latest" | grep -o '"tag_name": ".*"' | cut -d'"' -f4)

git clone https://github.com/gpac/gpac.git -b $latest_tag

cd gpac

./configure --static-bin

make -j $(nproc)

mv bin/gcc/MP4Box mp4box

tar -czvf $dir/mp4box-$latest_tag-$platform.tar.gz mp4box

cd $dir

#Build Media Info

mkdir mediainfo_build 

cd mediainfo_build

latest_tag=$(curl -s "https://api.github.com/repos/MediaArea/MediaInfo/releases/latest" | grep -o '"tag_name": ".*"' | cut -d'"' -f4)

git clone https://github.com/MediaArea/MediaInfo.git -b $latest_tag

git clone https://github.com/MediaArea/ZenLib.git

git clone https://github.com/MediaArea/MediaInfoLib.git -b $latest_tag

cd ZenLib/Project/GNU/Library
./autogen.sh
cd $dir/mediainfo_build

cd MediaInfoLib/Project/GNU/Library
./autogen.sh
cd $dir/mediainfo_build

cd MediaInfo/Project/GNU/CLI
./autogen.sh
cd $dir/mediainfo_build

mv MediaInfo/Project/GNU/CLI/AddThisToRoot_CLI_compile.sh compile.sh

bash compile.sh

mv MediaInfo/Project/GNU/CLI/mediainfo mediainfo

tar -czvf $dir/mediainfo-$latest_tag-linux-amd64.tar.gz mediainfo

cd $dir
