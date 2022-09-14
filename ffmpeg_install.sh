#!/bin/bash
set -e

#####
##### yum install autoconf automake bzip2 bzip2-devel cmake  gcc gcc-c++  zlib-devel python-devel libtool python3 python3-devel gperf glibc-static -y
##### yum install gcc-c++ cmake this version
####  -lstdc++ -stati may result dumps,so take care using it,dont use it as you can 





RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
PINK="\\033[35m"
BLACK="\\033[0m"


POS="\\033[76G"
s=$(printf "%-60s" ".")

ok_msg(){
    echo -e "${1}${s// /.}${POS}${BLACK}[${GREEN}  OK  ${BLACK}]"
}

skip_msg(){
    echo -e "${1}${s// /.}${POS}${BLACK}[${PINK} SKIP ${BLACK}]"
}

failed_msg(){
    echo -e "${1}${s// /.}${POS}${BLACK}[${RED}FAILED${BLACK}]"
}

print_failed(){
    echo -e ${RED}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${RED}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${RED}"####################################################### $1 ##################################################################"${BLACK}
}

print_ok(){
    echo -e ${GREEN}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${GREEN}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${GREEN}"####################################################### $1 ##################################################################"${BLACK}
}


print_warn(){
    echo -e ${YELLOW}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${YELLOW}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${YELLOW}"####################################################### $1 ##################################################################"${BLACK}
}

print_tips(){
    echo -e ${PINK}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${PINK}"####################################################### $1 ##################################################################"${BLACK}
    echo -e ${PINK}"####################################################### $1 ##################################################################"${BLACK}
}



current_dir=$(cd ../; pwd -P)
build_dir="${current_dir}/build"
release_dir="${current_dir}/release"
BIN_DIR="${current_dir}/bin"

print_tips "start to build the tools for transcode system(current_dir: ${current_dir}, build_dir: ${build_dir}, release_dir: ${release_dir})..."
 
mkdir -p ${build_dir}
mkdir -p ${release_dir}
mkdir -p ${BIN_DIR}

BUILDED_FLAG="_builed"

 
TARGET_DIR_SED=$(echo $release_dir | awk '{gsub(/\//, "\\/"); print}')

function install_yasm {

    YASM_LIB_PACKAGE=yasm-1.3.0.tar.gz
    YASM_LIB=$(basename ${YASM_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${YASM_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing yasm"

        if ! [ -e ${YASM_LIB_PACKAGE} ]
        then
            print_tips "${YASM_LIB} start downloading"
            wget http://www.tortall.net/projects/yasm/releases/${YASM_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${YASM_LIB_PACKAGE}
        pushd ${YASM_LIB}
        ./configure --prefix=${release_dir} --bindir=$BIN_DIR
        make
        make install
        if [ $? -ne 0 ] ; then
            print_failed "${YASM_LIB} install failed"
            exit 1
        fi
        popd
        touch ${YASM_LIB}${BUILDED_FLAG}
        print_ok "${YASM_LIB} fininsh installed"
    else
        print_tips "${YASM_LIB} already installed"
    fi
    popd
}

install_yasm

function install_nasm {

    NASM_LIB_PACKAGE=nasm-2.15.05.tar.gz
    NASM_LIB=$(basename ${NASM_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${NASM_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${NASM_LIB}"

        if ! [ -e ${NASM_LIB_PACKAGE} ]
        then
            print_tips "${NASM_LIB_PACKAGE} start downloading"
            wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/${NASM_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${NASM_LIB_PACKAGE}
        pushd ${NASM_LIB}
        ./configure --prefix=${release_dir} --bindir=$BIN_DIR
        make
        make install
        if [ $? -ne 0 ]; then
            print_failed "${NASM_LIB} install failed"
            exit 1
        fi
        popd
        touch ${NASM_LIB}${BUILDED_FLAG}
        print_ok "${NASM_LIB} fininsh installed"
    else
        print_tips "${NASM_LIB}  already installed"
    fi
    popd
}

install_nasm


function install_openssl {

    OPENSSL_LIB_PACKAGE=openssl-1.0.2.tar.gz
    OPENSSL_LIB=$(basename ${OPENSSL_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${OPENSSL_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${OPENSSL_LIB}"

        if ! [ -e ${OPENSSL_LIB_PACKAGE} ]
        then
            print_tips "${OPENSSL_LIB_PACKAGE} start downloading"
            wget https://www.openssl.org/source/old/1.0.2/${OPENSSL_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${OPENSSL_LIB_PACKAGE}
        pushd ${OPENSSL_LIB}
        PATH="$BIN_DIR:$PATH" ./config --prefix=${release_dir} -fPIC no-shared
        make
        make install
        if [ $? -ne 0 ]; then
            print_failed "${OPENSSL_LIB} install failed"
            exit 1
        fi
        popd
        touch ${OPENSSL_LIB}${BUILDED_FLAG}
        print_ok "${OPENSSL_LIB} fininsh installed"
    else
        print_tips "${OPENSSL_LIB}  already installed"
    fi
    popd
}

install_openssl




function install_libevent {

    LIBEVENT_LIB_PACKAGE=libevent-2.1.12-stable.tar.gz
    LIBEVENT_LIB=$(basename ${LIBEVENT_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBEVENT_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBEVENT_LIB}"

        if ! [ -e ${LIBEVENT_LIB} ]
        then
            print_tips "${LIBEVENT_LIB_PACKAGE} start downloading"
            wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/${LIBEVENT_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBEVENT_LIB_PACKAGE}
        pushd ${LIBEVENT_LIB}
        PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir}  --enable-static=yes --enable-shared=no --disable-openssl
        make
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBEVENT_LIB_PACKAGE} install failed"
            exit 1
        fi
        popd
        touch ${LIBEVENT_LIB}${BUILDED_FLAG}
        print_ok "${LIBEVENT_LIB_PACKAGE} fininsh installed"
    else
        print_tips "${LIBEVENT_LIB_PACKAGE}  already installed"
    fi
    popd
}


install_libevent



function install_libz {

    LIBZ_LIB_PACKAGE=zlib-1.2.8.tar.gz
    LIBZ_LIB=$(basename ${LIBZ_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBZ_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBZ_LIB}"

        if ! [ -e ${LIBZ_LIB} ]
        then
            print_tips "${LIBZ_LIB} start downloading"
            wget http://www.zlib.net/fossils/${LIBZ_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBZ_LIB_PACKAGE}
        pushd ${LIBZ_LIB}
        ./configure --prefix=${release_dir} --static
        make
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBZ_LIB} install failed"
            exit 1
        fi
        popd
        touch ${LIBZ_LIB}${BUILDED_FLAG}
        print_ok "${LIBZ_LIB} fininsh installed"
    else
        print_tips "${LIBZ_LIB}  already installed"
    fi
    popd
}

install_libz

function install_libbz2 {

    LIBBZ2_LIB_PACKAGE=bzip2-1.0.6.tar.gz
    LIBBZ2_LIB=$(basename ${LIBBZ2_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBBZ2_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBBZ2_LIB_PACKAGE}"

        if ! [ -e ${LIBBZ2_LIB_PACKAGE} ]
        then
            print_tips "${LIBBZ2_LIB} start downloading"
            wget sourceware.org/pub/bzip2/${LIBBZ2_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBBZ2_LIB_PACKAGE}
        pushd ${LIBBZ2_LIB}
        make PREFIX=${release_dir}
        make PREFIX=${release_dir} install
        if [ $? -ne 0 ]; then
            print_failed "${LIBBZ2_LIB} install failed"
            exit 1
        fi
        popd
        touch ${LIBBZ2_LIB}${BUILDED_FLAG}
        print_ok "${LIBBZ2_LIB} fininsh installed"
    else
        print_tips "${LIBBZ2_LIB}  already installed"
    fi
    popd
}

install_libbz2




function install_perl {

    PERL_LIB_PACKAGE=perl-5.26.1.tar.gz
    PERL_LIB=$(basename ${PERL_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${PERL_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${PERL_LIB_PACKAGE}"

        if ! [ -e ${PERL_LIB_PACKAGE} ]
        then
            print_tips "${PERL_LIB} start downloading"
            wget http://search.cpan.org/CPAN/authors/id/S/SH/SHAY/${PERL_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${PERL_LIB_PACKAGE}
        pushd ${PERL_LIB}
        PATH="$BIN_DIR:$PATH" ./Configure -des -Dprefix=${release}
        PATH="$BIN_DIR:$PATH" make -j16
        PATH="$BIN_DIR:$PATH" make install
        if [ $? -ne 0 ]; then
            print_failed "${PERL_LIB} install failed"
            exit 1
        fi
        popd
        touch ${PERL_LIB}${BUILDED_FLAG}
        print_ok "${PERL_LIB} fininsh installed"
    else
        print_tips "${PERL_LIB}  already installed"
    fi
    popd
}

install_perl



function install_m4 {

    M4_LIB_PACKAGE=m4-1.4.18.tar.gz
    M4_LIB=$(basename ${M4_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${M4_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${M4_LIB_PACKAGE}"

        if ! [ -e ${M4_LIB_PACKAGE} ]
        then
            print_tips "${M4_LIB} start downloading"
            wget http://mirrors.kernel.org/gnu/m4/${M4_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${M4_LIB_PACKAGE}
        pushd ${M4_LIB}
        PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --bindir=$BIN_DIR
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${M4_LIB} install failed"
            exit 1
        fi
        popd
        touch ${M4_LIB}${BUILDED_FLAG}
        print_ok "${M4_LIB} fininsh installed"
    else
        print_tips "${M4_LIB}  already installed"
    fi
    popd
}

install_m4




function install_autoconf {

    AUTOCONF_LIB_PACKAGE=autoconf-2.70.tar.gz
    AUTOCONF_LIB=$(basename ${AUTOCONF_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${AUTOCONF_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${AUTOCONF_LIB_PACKAGE}"

        if ! [ -e ${AUTOCONF_LIB_PACKAGE} ]
        then
            print_tips "${AUTOCONF_LIB} start downloading"
            wget ftp.gnu.org/gnu/autoconf/${AUTOCONF_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${AUTOCONF_LIB_PACKAGE}
        pushd ${AUTOCONF_LIB}
        PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --bindir=$BIN_DIR
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${AUTOCONF_LIB} install failed"
            exit 1
        fi
        popd
        touch ${AUTOCONF_LIB}${BUILDED_FLAG}
        print_ok "${AUTOCONF_LIB} fininsh installed"
    else
        print_tips "${AUTOCONF_LIB}  already installed"
    fi
    popd
}

#install_autoconf



function install_cmake {

    CMAKE_LIB_PACKAGE=cmake-3.10.0.tar.gz
    CMAKE_LIB=$(basename ${CMAKE_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${CMAKE_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${CMAKE_LIB}"

        if ! [ -e ${CMAKE_LIB_PACKAGE} ]
        then
            print_tips "${CMAKE_LIB} start downloading"
            wget https://cmake.org/files/v3.10/${CMAKE_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${CMAKE_LIB_PACKAGE}
        pushd ${CMAKE_LIB}
        PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --bindir=$BIN_DIR
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${CMAKE_LIB} install failed"
            exit 1
        fi
        popd
        touch ${CMAKE_LIB}${BUILDED_FLAG}
        print_ok "${CMAKE_LIB} fininsh installed"
    else
        print_tips "${CMAKE_LIB}  already installed"
    fi
    popd
}

install_cmake






function install_fdkacc {

    FDKACC_LIB_PACKAGE=fdk-aac-0.1.6.tar.gz
    FDKACC_LIB=$(basename ${FDKACC_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${FDKACC_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${FDKACC_LIB}"

        if ! [ -e ${FDKACC_LIB_PACKAGE} ]
        then
            print_tips "${FDKACC_LIB} start downloading"
            wget https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/${FDKACC_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${FDKACC_LIB_PACKAGE}
        pushd ${FDKACC_LIB}
        PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig/ ./configure --prefix=${release_dir} --enable-shared=no --enable-static=yes
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${FDKACC_LIB} install failed"
            exit 1
        fi
        popd
        touch ${FDKACC_LIB}${BUILDED_FLAG}
        print_ok "${FDKACC_LIB} fininsh installed"
    else
        print_tips "${FDKACC_LIB}  already installed"
    fi
    popd
}

install_fdkacc



function install_mp3lame {

    MP3LAME_LIB_PACKAGE=lame-3.100.tar.gz
    MP3LAME_LIB=$(basename ${MP3LAME_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${MP3LAME_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${MP3LAME_LIB}"

        if ! [ -e ${MP3LAME_LIB} ]
        then
            print_tips "${MP3LAME_LIB} start downloading"
            wget http://downloads.sourceforge.net/project/lame/lame/3.100/${MP3LAME_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${MP3LAME_LIB_PACKAGE}
        pushd ${MP3LAME_LIB}
        uname -a | grep -q 'aarch64' && lame_build_target="--build=arm-linux" || lame_build_target=''
        ./configure --prefix=${release_dir} --enable-nasm --disable-shared $lame_build_target 
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${MP3LAME_LIB_PACKAGE} install failed"
            exit 1
        fi
        popd
        touch ${MP3LAME_LIB}${BUILDED_FLAG}
        print_ok "${MP3LAME_LIB_PACKAGE} fininsh installed"
    else
        print_tips "${MP3LAME_LIB_PACKAGE}  already installed"
    fi
    popd
}

install_mp3lame








function install_libogg {

    LIBOGG_LIB_PACKAGE=libogg-1.3.2.tar.gz
    LIBOGG_LIB=$(basename ${LIBOGG_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBOGG_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBOGG_LIB_PACKAGE}"

        if ! [ -e ${LIBOGG_LIB_PACKAGE} ]
        then
            print_tips "${LIBOGG_LIB_PACKAGE} start downloading"
            wget http://downloads.xiph.org/releases/ogg/${LIBOGG_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBOGG_LIB_PACKAGE}
        pushd ${LIBOGG_LIB}
        PATH="$BIN_DIR:${release_dir}/bin:$PATH"  LDFLAGS="-L${release_dir}/lib" CPPFLAGS="-I${release_dir}/include" ./configure --prefix=${release_dir}  --disable-shared
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBOGG_LIB_PACKAGE} install failed"
            exit 1
        fi
        popd
        touch ${LIBOGG_LIB}${BUILDED_FLAG}
        print_ok "${LIBOGG_LIB_PACKAGE} fininsh installed"
    else
        print_tips "${LIBOGG_LIB_PACKAGE}  already installed"
    fi
    popd
}

install_libogg


function install_libvorbis {

    LIBVORBIS_LIB_PACKAGE=libvorbis-1.3.4.tar.gz
    LIBVORBIS_LIB=$(basename ${LIBVORBIS_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBOGG_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBVORBIS_LIB}"

        if ! [ -e ${LIBVORBIS_LIB} ]
        then
            print_tips "${LIBVORBIS_LIB} start downloading"
            wget http://downloads.xiph.org/releases/vorbis/${LIBVORBIS_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBVORBIS_LIB_PACKAGE}
        pushd ${LIBVORBIS_LIB}
        PATH="$BIN_DIR:${release_dir}/bin:$PATH"  LDFLAGS="-L${release_dir}/lib" CPPFLAGS="-I${release_dir}/include" ./configure --prefix=${release_dir}  --disable-shared
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBVORBIS_LIB_PACKAGE} install failed"
            exit 1
        fi
        popd
        touch ${LIBVORBIS_LIB}${BUILDED_FLAG}
        print_ok "${LIBVORBIS_LIB} fininsh installed"
    else
        print_tips "${LIBVORBIS_LIB}  already installed"
    fi
    popd
}

install_libvorbis




function install_opus {

    OPUS_LIB_PACKAGE=libvorbis-1.3.4.tar.gz
    OPUS_LIB=$(basename ${OPUS_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${OPUS_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${OPUS_LIB}"

        if ! [ -e ${OPUS_LIB} ]
        then
            print_tips "${OPUS_LIB} start downloading"
            wget ftp.mozilla.org/pub/opus/${OPUS_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${OPUS_LIB_PACKAGE}
        pushd ${OPUS_LIB}
        ./configure --prefix=${release_dir} --enable-shared=no --enable-static=yes
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${OPUS_LIB} install failed"
            exit 1
        fi
        popd
        touch ${OPUS_LIB}${BUILDED_FLAG}
        print_ok "${OPUS_LIB} fininsh installed"
    else
        print_tips "${OPUS_LIB}  already installed"
    fi
    popd
}

install_opus





function install_libx264 {

    LIBX264_LIB_PACKAGE=x264-stable.tar.gz
    LIBX264_LIB=$(basename ${LIBX264_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBX264_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBX264_LIB}"

        if ! [ -e ${LIBX264_LIB_PACKAGE} ]
        then
            print_tips "${LIBX264_LIB_PACKAGE} start downloading"
            wget https://code.videolan.org/videolan/x264/-/archive/stable/${LIBX264_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBX264_LIB_PACKAGE}
        pushd ${LIBX264_LIB}
        PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --enable-static  --disable-opencl --enable-pic
        PATH="$BIN_DIR:$PATH" make -j16 
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBX264_LIB_PACKAGE} install failed"
            exit 1
        fi
        popd
        touch ${LIBX264_LIB}${BUILDED_FLAG}
        print_ok "${LIBX264_LIB} fininsh installed"
    else
        print_tips "${LIBX264_LIB}  already installed"
    fi
    popd
}

install_libx264


function install_libvpx {

    LIBVPX_LIB_PACKAGE=libvpx_1.12.0.orig.tar.gz
    LIBVPX_LIB=$(basename ${LIBVPX_LIB_PACKAGE} .orig.tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBVPX_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBVPX_LIB_PACKAGE}"

        if ! [ -e ${LIBVPX_LIB_PACKAGE} ]
        then
            print_tips "${LIBVPX_LIB_PACKAGE} start downloading"
            wget mirrors.nju.edu.cn/kali/pool/main/libv/libvpx/${LIBVPX_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBVPX_LIB_PACKAGE}
        #pushd ${LIBVPX_LIB}
        pushd libvpx-1.12.0
        PATH="$BIN_DIR:$PATH" ./configure --prefix=${release_dir} --enable-static --disable-shared  --disable-examples --disable-unit-tests --enable-pic
        PATH="$BIN_DIR:$PATH" make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBVPX_LIB_PACKAGE} install failed"
            exit 1
        fi
        popd
        touch ${LIBVPX_LIB}${BUILDED_FLAG}
        print_ok "${LIBVPX_LIB_PACKAGE} fininsh installed"
    else
        print_tips "${LIBVPX_LIB_PACKAGE}  already installed"
    fi
    popd
}

install_libvpx





function install_libx265 {

    LIBX265_LIB_PACKAGE=x265_2.6.tar.gz
    LIBX265_LIB=$(basename ${LIBX265_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${LIBX265_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBX265_LIB_PACKAGE}"

        if ! [ -e ${LIBX265_LIB_PACKAGE} ]
        then
            print_tips "${LIBX265_LIB_PACKAGE} start downloading"
            wget http://mirrors.nju.edu.cn/videolan-ftp/x265/${LIBX265_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBX265_LIB_PACKAGE}

        pushd x265_v2.6
        pushd build/linux 
        PATH="${release_dir}/bin:${BIN_DIR}/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${release_dir}" -DENABLE_SHARED:BOOL=OFF -DBIN_INSTALL_DIR=${release_dir}/bin -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
        make -j16
        make install

        if [ $? -ne 0 ]; then
            print_failed "${LIBX265} install failed"
            exit 1
        fi
        popd
        touch ${LIBX265_LIB}${BUILDED_FLAG}
        print_ok "${LIBX265_LIB} fininsh installed"
    else
        print_tips "${LIBX265_LIB}  already installed"
    fi
    popd
}

install_libx265


function install_libpng {

    LIBPNG_LIB_PACKAGE=libpng-1.6.37.tar.xz
    LIBPNG_LIB=$(basename ${LIBPNG_LIB_PACKAGE} .tar.xz)

    pushd ${build_dir}
    if ! [ -e "${LIBPNG_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBPNG_LIB}"

        if ! [ -e ${LIBPNG_LIB_PACKAGE} ]
        then
            print_tips "${LIBPNG_LIB_PACKAGE} start downloading"
            wget https://downloads.sourceforge.net/libpng/${LIBPNG_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBPNG_LIB_PACKAGE}
        pushd ${LIBPNG_LIB}
       
        PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no
        PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig make -j16
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBPNG_LIB_PACKAGE} install failed"
            exit 1
        fi
        popd
        touch ${LIBPNG_LIB}${BUILDED_FLAG}
        print_ok "${LIBPNG_LIB} fininsh installed"
    else
        print_tips "${LIBPNG_LIB}  already installed"
    fi
    popd
}

install_libpng



function install_libxml2 {

    LIBXML2_LIB_PACKAGE=libxml2-2.9.14.tar.xz
    LIBXML2_LIB=$(basename ${LIBXML2_LIB_PACKAGE} .tar.xz)

    pushd ${build_dir}
    if ! [ -e "${LIBXML2_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${LIBXML2_LIB}"

        if ! [ -e ${LIBXML2_LIB} ]
        then
            print_tips "${LIBXML2_LIB} start downloading"
            wget https://download.gnome.org/sources/libxml2/2.9/${LIBXML2_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${LIBXML2_LIB_PACKAGE}

        pushd ${LIBXML2_LIB}
       
        PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no
        make
        make install
        if [ $? -ne 0 ]; then
            print_failed "${LIBXML2_LIB} install failed"
            exit 1
        fi
        popd
        touch ${LIBXML2_LIB}${BUILDED_FLAG}
        print_ok "${LIBXML2_LIB} fininsh installed"
    else
        print_tips "${LIBXML2_LIB}  already installed"
    fi
    popd
}

install_libxml2

function install_freetype {

    FREETYPE_LIB_PACKAGE=freetype-2.10.0.tar.bz2
    FREETYPE_LIB=$(basename ${FREETYPE_LIB_PACKAGE} .tar.bz2)

    pushd ${build_dir}
    if ! [ -e "${FREETYPE_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${FREETYPE_LIB}"

        if ! [ -e ${FREETYPE_LIB} ]
        then
            print_tips "${FREETYPE_LIB} start downloading"
            wget http://download.savannah.gnu.org/releases/freetype/${FREETYPE_LIB_PACKAGE} --no-check-certificate
            
        fi

        tar xf ${FREETYPE_LIB_PACKAGE}

        pushd ${FREETYPE_LIB}
        PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no
        make
        make install
       
       
        if [ $? -ne 0 ]; then
            print_failed "${FREETYPE_LIB} install failed"
            exit 1
        fi
        popd
        touch ${FREETYPE_LIB}${BUILDED_FLAG}
        print_ok "${FREETYPE_LIB} fininsh installed"
    else
        print_tips "${FREETYPE_LIB}  already installed"
    fi
    popd
}

install_freetype


function install_fontconfig {

    FONTCONFIG_LIB_PACKAGE=fontconfig-2.13.95.tar.gz
    FONTCONFIG_LIB=$(basename ${FONTCONFIG_LIB_PACKAGE} .tar.gz)

    pushd ${build_dir}
    if ! [ -e "${FONTCONFIG_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${FONTCONFIG_LIB}"

        if ! [ -e ${FONTCONFIG_LIB} ]
        then
            print_tips "${FONTCONFIG_LIB} start downloading"
            wget http://download.savannah.gnu.org/releases/freetype/${FONTCONFIG_LIB_PACKAGE} --no-check-certificate
            
        fi

        tar xf ${FONTCONFIG_LIB_PACKAGE}
        pushd ${FONTCONFIG_LIB}
        PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig ./configure --prefix=${release_dir} --enable-static=yes --enable-shared=no --enable-libxml2
        PATH="$BIN_DIR:$PATH" PKG_CONFIG_PATH=${release_dir}/lib/pkgconfig make
        make install
       
        if [ $? -ne 0 ]; then
            print_failed "${FONTCONFIG_LIB} install failed"
            exit 1
        fi
        popd
        touch ${FONTCONFIG_LIB}${BUILDED_FLAG}
        print_ok "${FONTCONFIG_LIB} fininsh installed"
    else
        print_tips "${FONTCONFIG_LIB}  already installed"
    fi
    popd
}


function install_ffmpeg5.1 {

    FFMPEG_LIB_PACKAGE=ffmpeg-5.1.tar.xz
    FFMPEG_LIB=$(basename ${FFMPEG_LIB_PACKAGE} .tar.xz)

    pushd ${build_dir}
    if ! [ -e "${FFMPEG_LIB}${BUILDED_FLAG}" ]
    then
        print_tips "start installing ${FFMPEG_LIB}"

        if ! [ -e ${FFMPEG_LIB_PACKAGE} ]
        then
            print_tips "${FFMPEG_LIB} start downloading"
            wget https://ffmpeg.org/releases/${FFMPEG_LIB_PACKAGE} --no-check-certificate
        fi

        tar xf ${FFMPEG_LIB_PACKAGE}
        pushd ${FFMPEG_LIB}

        PATH="${BIN_DIR}:${release_dir}/bin:$PATH" PKG_CONFIG_PATH="${release_dir}/lib/pkgconfig" ./configure --prefix=${release_dir}  \
        --extra-cflags="-I${release_dir}/include" \
        --extra-ldflags="-L${release_dir}/lib -L${release_dir}/lib64" \
        --extra-libs='-lpthread -lm -lz' \
        --pkg-config-flags=--static \
        --enable-static \
        --extra-libs=-lpthread \
        --extra-libs=-lm \
        --bindir=${release_dir}/bin \
        --enable-gpl \
        --enable-static \
        --disable-shared \
        --enable-libfdk_aac \
        --enable-libmp3lame \
        --enable-libx264 \
        --enable-pthreads \
        --enable-libfreetype \
        --enable-libfontconfig \
        --enable-libopus \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-nonfree \
        --extra-ldflags="-L/root/dev_env/release/lib -ldl -lm -lpthread -lrt -static"

        if [ $? -ne 0 ]; then
            print_failed "${FFMPEG_LIB} install failed"
            exit 1
        fi
        popd
        touch ${FFMPEG_LIB}${BUILDED_FLAG}
        print_ok "${FFMPEG_LIB} fininsh installed"
    else
        print_tips "${FFMPEG_LIB}  already installed"
    fi
    popd
}

install_ffmpeg5.1






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
#wget https://github.com/libass/libass/archive/0.13.6.tar.gz --no-check-certificate
#wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz  --no-check-certificate
#wget ftp.mozilla.org/pub/opus/opus-1.1.2.tar.gz --no-check-certificate
#wget https://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz --no-check-certificate
#wget https://ffmpeg.org/releases/ffmpeg-4.4.2.tar.xz --no-check-certificate
#wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz --no-check-certificate

#PATH="/root/bin:$PATH" PKG_CONFIG_PATH="$release_dir/lib/pkgconfig" ./configure --prefix=$release_dir  --extra-cflags="-I$release_dir/include" --extra-ldflags="-L$release_dir/lib -L$release_dir/lib64" --extra-libs='-lpthread -lm -lz' --bindir=/root/ffmpeg-static/bin-ldl --pkg-config-flags="--static" --enable-gpl --enable-static --enable-nonfree --enable-version3 --enable-libx264 --enable-libx265 --enable-pthreads --enable-protocol=rtmp --enable-demuxer=rtsp --enable-bsf=extract_extradata --enable-muxer=flv --enable-libfdk-aac --enable-libfreetype --enable-libfontconfig --enable-sdl --extra-libs=-levent


