#!/bin/bash
set -e

#####
##### yum install autoconf automake bzip2 bzip2-devel cmake  gcc gcc-c++  zlib-devel python-devel libtool -y
##### yum install gcc-c++ cmake this version
####  -lstdc++ -stati may result dumps,so take care using it,dont use it as you can 

current_dir=$(cd ../; pwd -P)
build_dir="${current_dir}/build"
release_dir="${current_dir}/release"
BIN_DIR="${current_dir}/bin"
echo "start to build the tools for transcode system(current_dir: ${current_dir}, build_dir: ${build_dir}, release_dir: ${release_dir})..."
 
mkdir -p ${build_dir}
mkdir -p ${release_dir}
mkdir -p ${BIN_DIR}


 
TARGET_DIR_SED=$(echo $release_dir | awk '{gsub(/\//, "\\/"); print}')

# yasm 
pushd ${build_dir}
if ! [ -e "yasm" ]
then
    echo "########## yasm begin ##########"
    if ! [ -e "yasm-1.3.0.tar.gz" ]
    then
        # download yasm
        echo "########## to download yasm ##########"
        wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz --no-check-certificate
    fi
 
    tar xf yasm-1.3.0.tar.gz
    pushd yasm-1.3.0
    ./configure --prefix=${release_dir} --bindir=$BIN_DIR
    make
    make install
    popd
    touch yasm
    echo "########## yasm ok ##########"
else
    echo "########## yasm has been installed ##########"
fi
popd




# nasm
pushd ${build_dir}
if ! [ -e "nasm" ]
then
    echo "########## nasm begin ##########"
    if ! [ -e "nasm-2.15.05.tar.gz" ]
    then
        # download nasm
        echo "########## to download nasm ##########"
        wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz --no-check-certificate
    fi

    tar xf nasm-2.15.05.tar.gz
    pushd nasm-2.15.05
    ./configure --prefix=${release_dir} --bindir=$BIN_DIR
    make
    make install
    popd
    touch nasm
    echo "########## nasm ok ##########"
else
    echo "########## nasm has been installed ##########"
fi
popd

## openssl
pushd ${build_dir}
if ! [ -e "openssl" ]
then
    echo "########## openssl begin ##########"
    if ! [ -e "openssl-1.0.2.tar.gz" ]
    then
        # download openssl
        echo "########## to download openssl ##########"
        #wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz --no-check-certificate
        wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2.tar.gz --no-check-certificate
    fi

    tar xf openssl-1.0.2.tar.gz
    pushd openssl-1.0.2
    PATH="$BIN_DIR:$PATH" ./config --prefix=${release_dir} -fPIC no-shared
    make
    make install
    popd
    touch openssl
    echo "########## openssl ok ##########"
else
    echo "########## openssl has been installed ##########"
fi
popd


# libevent
pushd ${build_dir}
if ! [ -e "libevent" ]
then
    echo "########## libevent begin ##########"
 
    if ! [ -e "libevent-2.1.12-stable.tar.gz" ]
    then
        # download libevent
        echo "########## to download libevent ##########"
        wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz --no-check-certificate
    fi
 
    tar xf libevent-2.1.12-stable.tar.gz
    pushd libevent-2.1.12-stable
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir}  --enable-static=yes --enable-shared=no --disable-openssl
    make
    make install
    popd
    touch libevent
    echo "########## libevent ok ##########"
else
    echo "########## libevent has been installed ##########"
fi
popd



# libz
pushd ${build_dir}
if ! [ -e "zlib" ]
then
    echo "########## zlib begin ##########"
    # wget http://zlib.net/zlib-1.2.8.tar.gz  
    if ! [ -e "zlib-1.2.10.tar.gz" ]
    then
        # download zlib
        echo "########## to download zlib ##########"
        wget http://www.zlib.net/fossils/zlib-1.2.10.tar.gz --no-check-certificate
    fi
   
 
    tar xf zlib-1.2.10.tar.gz
    pushd zlib-1.2.10
    ./configure --prefix=${release_dir} --static
    make
    make install
    popd
    touch zlib
    echo "########## zlib ok ##########"
else
    echo "########## zlib has been installed ##########"
fi
popd


# libbz2
pushd ${build_dir}
if ! [ -e "libbz2" ]
then
    echo "########## libbz2 begin ##########"
    # wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
 
    if ! [ -e "bzip2-1.0.6.tar.gz" ]
    then
        # download bzip2
        echo "########## to download bzip2 ##########"
        wget sourceware.org/pub/bzip2/bzip2-1.0.6.tar.gz --no-check-certificate
    fi

    tar xf bzip2-1.0.6.tar.gz
    pushd bzip2-1.0.6
    #./configure --prefix=${release_dir} --bindir=$BIN_DIR
    make PREFIX=${release_dir}
    make PREFIX=${release_dir} install
    popd
    touch libbz2
    echo "########## libbz2 ok ##########"
else
    echo "########## libbz2 has been installed ##########"
fi
popd

BIN_DIR="${current_dir}/bin"
echo "**************************************BIN_DIR  $BIN_DIR**********************************************************"



# perl
pushd ${build_dir}
if ! [ -e "perl" ]
then
    echo "########## perl begin ##########"
    # wget http://search.cpan.org/CPAN/authors/id/S/SH/SHAY/perl-5.26.1.tar.gz

    if ! [ -e "perl-5.26.1.tar.gz" ]
    then
        # download perl
        echo "########## to download perl ##########"
        wget http://search.cpan.org/CPAN/authors/id/S/SH/SHAY/perl-5.26.1.tar.gz
    fi

    tar xf perl-5.26.1.tar.gz
    pushd perl-5.26.1
    PATH="$BIN_DIR:$PATH" ./Configure -des -Dprefix=${release}
    PATH="$BIN_DIR:$PATH" make -j16
    make install
    popd
    touch perl
    echo "########## perl ok ##########"
else
    echo "########## perl has been installed ##########"
fi
popd

# m4
pushd ${build_dir}
if ! [ -e "m4" ]
then
    echo "########## m4 begin ##########"
    # wget http://mirrors.kernel.org/gnu/m4/m4-1.4.18.tar.gz

    if ! [ -e "m4-1.4.18.tar.gz" ]
    then
        # download m4
        echo "########## to download m4 ##########"
        wget http://mirrors.kernel.org/gnu/m4/m4-1.4.18.tar.gz --no-check-certificate
    fi

    tar xf m4-1.4.18.tar.gz
    pushd m4-1.4.18
    PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --bindir=$BIN_DIR
    PATH="$BIN_DIR:$PATH" make -j16
    make install
    popd
    touch m4
    echo "########## m4 ok ##########"
else
    echo "########## m4 has been installed ##########"
fi
popd

# autoconf
pushd ${build_dir}
if ! [ -e "autoconf" ]
then
    echo "########## autoconf begin ##########"
    # wget ftp.gnu.org/gnu/autoconf/autoconf-2.70.tar.gz

    if ! [ -e "autoconf-2.70.tar.gz" ]
    then
        # download autoconf
        echo "########## to download autoconf ##########"
        wget ftp.gnu.org/gnu/autoconf/autoconf-2.70.tar.gz --no-check-certificate
    fi

    tar xf autoconf-2.70.tar.gz
    pushd autoconf-2.70
    PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --bindir=$BIN_DIR
    PATH="$BIN_DIR:$PATH" make -j16
    make install
    popd
    touch autoconf
    echo "########## autoconf ok ##########"
else
    echo "########## autoconf has been installed ##########"
fi
popd

# cmake
pushd ${build_dir}
if ! [ -e "cmake" ]
then
    echo "########## cmake begin ##########"
    # wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz
    if ! [ -e "cmake-3.10.0.tar.gz" ]
    then
        # download cmake
        echo "########## to download cmake ##########"
        wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz --no-check-certificate
    fi

    tar xf cmake-3.10.0.tar.gz
    pushd cmake-3.10.0
    ###### remind the dir of cmake installing,see configure --help

    PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --bindir=bin
    PATH="$BIN_DIR:$PATH" make -j16
    make install
    popd
    touch cmake
    echo "########## cmake ok ##########"
else
    echo "########## cmake has been installed ##########"
fi
popd




# fdk-aac
pushd ${build_dir}
if ! [ -e "fdk-aac" ]
then
    echo "########## fdk-aac begin ##########"


    if ! [ -e "fdk-aac-0.1.6.tar.gz" ]
    then
        # download fdk-acc
        echo "########## to download fdk-acc ##########"
        wget https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.6.tar.gz --no-check-certificate
    fi

    tar xf fdk-aac-0.1.6.tar.gz
    pushd fdk-aac-0.1.6
    PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig/ ./configure --prefix=${release_dir} --enable-shared=no --enable-static=yes
    make -j16
    make install
    popd
    touch fdk-aac
    echo "########## fdk-aac ok ##########"
else
    echo "########## fdk-aac has been installed ##########"
fi
popd


# libmp3lame
pushd ${build_dir} 
if ! [ -e "mp3lame" ]
then
    echo "########## libmp3lame begin ##########"

    if ! [ -e "lame-3.100.tar.gz" ]
    then
        # download lame-3.100.tar.gz
        echo "########## to download libmp3lame  ##########"
        wget http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz --no-check-certificate
    fi

    tar xf lame-3.100.tar.gz
    pushd lame-3.100

    uname -a | grep -q 'aarch64' && lame_build_target="--build=arm-linux" || lame_build_target=''
    ./configure --prefix=${release_dir} --enable-nasm --disable-shared $lame_build_target
    make
    make install
    popd
    touch mp3lame
    echo "########## libmp3lame ok ##########"
else
    echo "########## libmp3lame has been installed ##########"
fi
popd





# opus
pushd ${build_dir}
if ! [ -e "opus" ]
then
    echo "########## opus begin ##########"

    if ! [ -e "opus-1.1.2.tar.gz" ]
    then
        # download opus-1.1.2.tar.gz
        echo "########## to download opus  ##########"
        wget ftp.mozilla.org/pub/opus/opus-1.1.2.tar.gz --no-check-certificate
    fi

    tar xf opus-1.1.2.tar.gz
    pushd opus-1.1.2
    ./configure --prefix=${release_dir} --enable-shared=no --enable-static=yes
    make
    make install
    popd
    touch opus
    echo "########## opus ok ##########"
else
    echo "########## opus has been installed ##########"
fi
popd





# libx264
pushd ${build_dir} 
if ! [ -e "x264" ]
then
    echo "########## libx264 begin ##########"
    if ! [ -e "x264-stable.tar.gz" ]
    then
        # download x264-stable.tar.gz
        echo "########## to download libx264  ##########"
        wget https://code.videolan.org/videolan/x264/-/archive/stable/x264-stable.tar.gz --no-check-certificate
    fi




    tar xf x264-stable.tar.gz
    pushd x264-stable
    PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --enable-static  --disable-opencl --enable-pic
    PATH="$BIN_DIR:$PATH" make -j16 
    make install
    popd
    touch x264
    echo "########## libx264 ok ##########"
else
    echo "########## libx264 has been installed ##########"
fi
popd


# libvpx
pushd ${build_dir}
if ! [ -e "libvpx" ]
then
    echo "########## libvpx begin ##########"
    if ! [ -e "libvpx_1.12.0.orig.tar.gz" ]
    then
        # download libvpx_1.12.0.orig.tar.gz
        echo "########## to download libvpx  ##########"
        wget mirrors.nju.edu.cn/kali/pool/main/libv/libvpx/libvpx_1.12.0.orig.tar.gz --no-check-certificate
    fi




    tar xf libvpx_1.12.0.orig.tar.gz
    pushd libvpx-1.12.0
    PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --enable-static --disable-shared  --disable-examples --disable-unit-tests --enable-pic
    PATH="$BIN_DIR:$PATH" make -j16
    make install
    popd
    touch libvpx
    echo "########## libvpx ok ##########"
else
    echo "########## libvpx has been installed ##########"
fi
popd



# libx265
pushd ${build_dir} 
if ! [ -e "x265" ]
then
    echo "########## libx265 begin ##########"
    if ! [ -e "x265_2.6.tar.gz" ]
    then
        # download x265_2.6.tar.gz
        echo "########## to download x265  ##########"
        wget http://mirrors.nju.edu.cn/videolan-ftp/x265/x265_2.6.tar.gz --no-check-certificate
    fi


    # download page: wget http://mirrors.nju.edu.cn/videolan-ftp/x265/x265_2.6.tar.gz
    tar xf x265_2.6.tar.gz
    pushd x265_v2.6
    pushd build/linux 
    PATH="${release_dir}/bin:${BIN_DIR}/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${release_dir}" -DENABLE_SHARED:BOOL=OFF -DBIN_INSTALL_DIR=/root/release/bin -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
#    PATH="${release_dir}/bin:${BIN_DIR}:$PATH" cmake ./source -DCMAKE_INSTALL_PREFIX=${release_dir} -DBUILD_SHARED_LIBS=OFF -DBIN_INSTALL_DIR=${release_dir}/bin
#    #cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
     make -j16
    make install
    popd
    popd
    touch x265
    echo "########## libx265 ok ##########"
else
    echo "########## libx265 has been installed ##########"
fi
popd







# libpng
pushd ${build_dir}
if ! [ -e "libpng" ]
then
    echo "########## libpng begin ##########"
    if ! [ -e "libpng-1.6.37.tar.xz" ]
    then
        # download libpng
        echo "########## to download libpng-1.6.37.tar.xz  ##########"
        wget https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz --no-check-certificate
    fi

    tar xf libpng-1.6.37.tar.xz
    pushd libpng-1.6.37
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig make -j16
    make install
    popd
    touch libpng
    echo "########## libpng ok ##########"
else
    echo "########## libpng has been installed ##########"
fi
popd


# libxml2 (requried by fontconfig)
pushd ${build_dir} 
if ! [ -e "libxml2" ]
then
    echo "########## libxml2 begin ##########"

    if ! [ -e "libxml2-2.9.14.tar.xz" ]
    then
        # download libxml2
        echo "########## to download libxml2-2.9.14.tar.xz  ##########"
        wget https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.14.tar.xz --no-check-certificate
    fi

    tar xf libxml2-2.9.14.tar.xz
    pushd libxml2-2.9.14
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no
    make
    make install
    popd
    touch libxml2
    echo "########## libxml2 ok ##########"
else
    echo "########## libxml2 has been installed ##########"
fi
popd


# freetype (requried by fontconfig)
pushd ${build_dir}
if ! [ -e "freetype" ]
then
    echo "########## freetype begin ##########"

    if ! [ -e "freetype-2.10.0.tar.bz2" ]
    then
        # download freetype-2.10.0
        echo "########## to download freetype-2.10.0.tar.bz2  ##########"
        wget http://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2 --no-check-certificate
    fi

    tar xf freetype-2.10.0.tar.bz2
    pushd freetype-2.10.0
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no
    make
    make install
    popd
    touch freetype
    echo "########## freetype ok ##########"
else
    echo "########## freetype has been installed ##########"
fi
popd    


# fribidi (requried by fontconfig)
pushd ${build_dir}
if ! [ -e "fribidi" ]
then
    echo "########## fribidi begin ##########"

    if ! [ -e "fribidi" ]
    then
        # download fribidi-1.0.11
        echo "########## to download fribidi-1.0.11.tar.xz  ##########"
        wget https://github.com/fribidi/fribidi/releases/download/v1.0.11/fribidi-1.0.11.tar.xz --no-check-certificate
    fi

    tar xf fribidi-1.0.11.tar.xz
    pushd fribidi-1.0.11
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no
    make
    make install
    popd
    touch fribidi
    echo "########## fribidi ok ##########"
else
    echo "########## fribidi has been installed ##########"
fi
popd






# fontconfig (requried by fontconfig)
pushd ${build_dir}
if ! [ -e "fontconfig" ]
then
    echo "########## fontconfig begin ##########"

    if ! [ -e "fontconfig" ]
    then
        # download fontconfig
        echo "########## to download fontconfig-2.13.95.tar.gz  ##########"
        wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.95.tar.gz --no-check-certificate
    fi

    tar xf fontconfig-2.13.95.tar.gz
    pushd fontconfig-2.13.95
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no --enable-libxml2
    PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig make
    make install
    popd
    touch fontconfig
    echo "########## fontconfig ok ##########"
else
    echo "########## fontconfig has been installed ##########"
fi
popd

















# ffmpeg
pushd ${build_dir} 
if ! [ -e "ffmpeg-5.1" ]
then
    echo "########## ffmepg begin ##########"
    set -x
 
    if ! [ -e "ffmpeg-5.1.tar.xz" ]
    then
        # download ffmpeg-5.1.tar.xz
        echo "########## to download ffmpeg-5.1.tar.xz  ##########"
        wget https://ffmpeg.org/releases/ffmpeg-5.1.tar.xz --no-check-certificate
    fi
    
    echo "remove all so to force the ffmpeg to build in static"
    rm -f ${release_dir}/lib/*.so*
 
    tar xf ffmpeg-5.1.tar.xz
    pushd ffmpeg-5.1
 
    #export ffmpeg_exported_release_dir=${release_dir}
    #echo ${ffmpeg_exported_release_dir}/include
    #echo ${ffmpeg_exported_release_dir}/lib
 

    PATH="${BIN_DIR}:${release_dir}/bin:$PATH" PKG_CONFIG_PATH="${release_dir}/lib/pkgconfig" ./configure --prefix=${release_dir} \
    --pkg-config-flags=--static \
    --extra-cflags=-I${release_dir}/include \
    --extra-ldflags='-L${release_dir}/lib -L${release_dir}/lib64 -ldl -lm -lpthread -lrt -static' \
    --extra-libs='-lpthread -lm' \
    --bindir=${release_dir}/bin \
    --enable-gpl \
    --enable-static \
    --disable-shared \
    --enable-libfdk_aac \
    --enable-libopus \
    --enable-libvpx \
    --enable-libx264  \
    --enable-libfreetype \
    --enable-libfontconfig \
    --enable-libfribidi \
    --enable-nonfree






    #PATH="${release_dir}/bin:${BIN_DIR}:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig/ ./configure \
    #--prefix="${release_dir}" \
    #--extra-cflags="-I${release_dir}/include" \
    #--extra-ldflags="-L${release}/lib -ldl -lm -lpthread -lrt -lstdc++ -static" \
    #--pkg-config-flags="--static" \
    #--enable-static \
    #--extra-libs=-lpthread \
    #--extra-libs=-lm \
    #--bindir="${release_dir}/bin" \
    #--enable-gpl \
    #--enable-static \
    #--disable-shared \
    #--enable-libfdk_aac \
    #--enable-libopus \
    #--enable-libvpx \
    #--enable-libx264 \
    #--enable-nonfree



 
    #./configure --prefix=${release_dir} --cc=$CC \
    #--extra-cflags="-I${release_dir}/include -I${release_dir}/include/hiredis" \
    #--extra-ldflags="-L${release_dir}/lib -L${release_dir}/lib64 -ldl -lm -lpthread -lrt -lstdc++ -static" \
    #--pkg-config-flags="--static" \
    #--enable-gpl --enable-static --enable-nonfree --enable-version3 --disable-ffplay --disable-ffserver \
    #--enable-postproc \
    #--enable-demuxer=oss \
    #--disable-vaapi --disable-indev=alsa --disable-outdev=alsa \
    #--enable-libopencore-amrnb --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libfaac --enable-libfdk-aac \
    #--enable-libass --enable-libfreetype --enable-libfontconfig --enable-libfribidi \
    #--extra-libs=-lhiredis --extra-libs=-lnuma --extra-libs=-levent 
    #--extra-libs=-lstdc++ --extra-libs=-lc
 
    echo "ffmpeg-5.1 begin make"
    PATH="${release_dir}/bin/:${BIN_DIR}:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig/ make -j16
    make install
    popd
    touch ffmpeg-5.1
    echo "########## ffmpeg-5.1 ok ##########"
else
    echo "########## ffmpeg-5.1 has been installed ##########"
fi
popd


#wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz --no-check-certificate
#wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz --no-check-certificate
#wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz --no-check-certificate
#wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz --no-check-certificate
#wget http://www.zlib.net/fossils/zlib-1.2.10.tar.gz --no-check-certificate
#wget sourceware.org/pub/bzip2/bzip2-1.0.6.tar.gz --no-check-certificate
#wget http://search.cpan.org/CPAN/authors/id/S/SH/SHAY/perl-5.26.1.tar.gz
#wget http://mirrors.kernel.org/gnu/m4/m4-1.4.18.tar.gz --no-check-certificate
#wget ftp.gnu.org/gnu/autoconf/autoconf-2.70.tar.gz --no-check-certificate
#wget https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.6.tar.gz --no-check-certificate
#wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz --no-check-certificate
#wget ftp.mozilla.org/pub/opus/opus-1.1.2.tar.gz --no-check-certificate
#wget https://code.videolan.org/videolan/x264/-/archive/stable/x264-stable.tar.gz --no-check-certificate
#wget mirrors.nju.edu.cn/kali/pool/main/libv/libvpx/libvpx_1.10.0.orig.tar.gz --no-check-certificate
#wget http://mirrors.nju.edu.cn/videolan-ftp/x265/x265_3.2.tar.gz --no-check-certificate
#wget https://ffmpeg.org/releases/ffmpeg-4.4.2.tar.xz --no-check-certificate
#wget https://tukaani.org/xz/xz-5.2.2.tar.gz --no-check-certificate

#wget https://sourceforge.net/projects/libpng/files/libpng12/1.2.58/libpng-1.2.58.tar.xz --no-check-certificate

#wget http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz --no-check-certificate 

#wget http://download.savannah.gnu.org/releases/freetype/freetype-2.10.2.tar.gz --no-check-certificate

#wget http://mirrors.nju.edu.cn/ubuntu/pool/main/f/fribidi/fribidi_0.19.7.orig.tar.bz2 --no-check-certificate

#wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.gz --no-check-certificate

#wget https://github.com/libass/libass/archive/0.13.6.tar.gz --no-check-certificate

#wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz  --no-check-certificate
#wget ftp.mozilla.org/pub/opus/opus-1.1.2.tar.gz --no-check-certificate

#wget https://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz --no-check-certificate

#wget https://ffmpeg.org/releases/ffmpeg-4.4.2.tar.xz --no-check-certificate

#wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz --no-check-certificate



#PATH="/root/bin:$PATH" PKG_CONFIG_PATH="$release_dir/lib/pkgconfig" ./configure --prefix=$release_dir  --extra-cflags="-I$release_dir/include" --extra-ldflags="-L$release_dir/lib -L$release_dir/lib64" --extra-libs='-lpthread -lm -lz' --bindir=/root/ffmpeg-static/bin-ldl --pkg-config-flags="--static" --enable-gpl --enable-static --enable-nonfree --enable-version3 --enable-libx264 --enable-libx265 --enable-pthreads --enable-protocol=rtmp --enable-demuxer=rtsp --enable-bsf=extract_extradata --enable-muxer=flv --enable-libfdk-aac --enable-libfreetype --enable-libfontconfig --enable-sdl --extra-libs=-levent


#PATH="/root/bin:$PATH" PKG_CONFIG_PATH="$release_dir/lib/pkgconfig" ./configure --prefix=/root/release --pkg-config-flags=--static --extra-cflags=-I/root/release/include --extra-ldflags='-L/root/release/lib -ldl -lm -lpthread -lrt -lstdc++ -static' --extra-libs=-lpthread --extra-libs=-lm --bindir=/root/release/bin --enable-gpl --enable-static --disable-shared --enable-libfdk_aac --enable-libopus --enable-libvpx --enable-libx264 --enable-libx265 --enable-nonfree
