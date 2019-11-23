using BinaryBuilder

HELICS_VERSION = v"2.3.1"

sources = [
    (
        "https://github.com/GMLC-TDC/HELICS/releases/download/v$HELICS_VERSION/Helics-v$HELICS_VERSION-source.tar.gz"
        =>
        "ffc4c8fa8fa593186a64288849a69c707ed91820448ff965947e32cdd54f9308"
    ),
]

script = raw"""
cd $WORKSPACE/srcdir

mkdir build
cd build
BOOST_ARGS="-DBOOST_INCLUDEDIR=$WORKSPACE/destdir/include -DBOOST_ROOT=$WORKSPACE/destdir -DBoost_NO_BOOST_CMAKE=ON"
CMAKE_ARGS="-DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_BUILD_TYPE=Release"
HELICS_ARGS="-DHELICS_BUILD_TESTS=OFF"
cmake ${CMAKE_ARGS} ${BOOST_ARGS} ${HELICS_ARGS} ..
make -j${nproc}
make install
"""

products(prefix) = [
    LibraryProduct(prefix, "libhelicsSharedLib", :libhelicsSharedLib),
]

platforms = [
    # Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4)),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7)),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4)),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7)),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4)),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7)),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4)),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7)),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8)),
    # Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)),
    # MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)),
    # FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4)),
    # FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7)),
    # FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8)),
    # Windows(:i686, compiler_abi=CompilerABI(:gcc4)),
    # Windows(:i686, compiler_abi=CompilerABI(:gcc7)),
    # Windows(:i686, compiler_abi=CompilerABI(:gcc8)),
    # Windows(:x86_64, compiler_abi=CompilerABI(:gcc4)),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)),
]

dependencies = [
                "https://github.com/benlorenz/boostBuilder/releases/download/v1.71.0-1/build_boost.v1.71.0.jl",
                "https://github.com/kdheepak/ZMQBuilder/releases/download/v4.3.1/build_ZMQ.v4.3.1.jl",
]

# Build 'em!
build_tarballs(
    ARGS,
    "libhelicsSharedLib",
    HELICS_VERSION,
    sources,
    script,
    platforms,
    products,
    dependencies,
)

