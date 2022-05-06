#!/bin/bash
set -e

#####
##### yum install autoconf automake bzip2 bzip2-devel cmake  gcc gcc-c++  zlib-devel python-devel libtool -y
#####
 
current_dir=$(cd ../; pwd -P)
build_dir="${current_dir}/build"
release_dir="${current_dir}/release"
echo "start to build the tools for transcode system(current_dir: ${current_dir}, build_dir: ${build_dir}, release_dir: ${release_dir})..."
 
mkdir -p ${build_dir}
mkdir -p ${release_dir}


 
TARGET_DIR_SED=$(echo $release_dir | awk '{gsub(/\//, "\\/"); print}')


wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz --no-check-certificate
wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz --no-check-certificate
wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz --no-check-certificate
wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz --no-check-certificate
wget https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.6.tar.gz --no-check-certificate

wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz --no-check-certificate

wget https://code.videolan.org/videolan/x264/-/archive/stable/x264-stable.tar.gz --no-check-certificate

wget http://mirrors.nju.edu.cn/videolan-ftp/x265/x265_3.2.tar.gz --no-check-certificate

wget https://tukaani.org/xz/xz-5.2.2.tar.gz --no-check-certificate

wget https://sourceforge.net/projects/libpng/files/libpng12/1.2.58/libpng-1.2.58.tar.xz --no-check-certificate

wget http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz --no-check-certificate 

wget http://download.savannah.gnu.org/releases/freetype/freetype-2.10.2.tar.gz --no-check-certificate

wget http://mirrors.nju.edu.cn/ubuntu/pool/main/f/fribidi/fribidi_0.19.7.orig.tar.bz2 --no-check-certificate

wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.gz --no-check-certificate

wget https://github.com/libass/libass/archive/0.13.6.tar.gz --no-check-certificate

wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz  --no-check-certificate
wget ftp.mozilla.org/pub/opus/opus-1.1.2.tar.gz --no-check-certificate
wget mirrors.nju.edu.cn/kali/pool/main/libv/libvpx/libvpx_1.10.0.orig.tar.gz --no-check-certificate

wget https://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz --no-check-certificate

wget https://ffmpeg.org/releases/ffmpeg-4.4.2.tar.xz --no-check-certificate

wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz --no-check-certificate








PATH="/root/bin:$PATH" PKG_CONFIG_PATH="$release_dir/lib/pkgconfig" ./configure --prefix=$release_dir  --extra-cflags="-I$release_dir/include" --extra-ldflags="-L$release_dir/lib -L$release_dir/lib64" --extra-libs='-lpthread -lm -lz' --bindir=/root/ffmpeg-static/bin-ldl --pkg-config-flags="--static" --enable-gpl --enable-static --enable-nonfree --enable-version3 --enable-libx264 --enable-libx265 --enable-pthreads --enable-protocol=rtmp --enable-demuxer=rtsp --enable-bsf=extract_extradata --enable-muxer=flv --enable-libfdk-aac --enable-libfreetype --enable-libfontconfig --enable-sdl --extra-libs=-levent
