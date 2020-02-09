using BinaryBuilder

HELICS_VERSION = v"2.4.0"

sources = [
    (
        "https://github.com/GMLC-TDC/HELICS/releases/download/v$HELICS_VERSION/Helics-v$HELICS_VERSION-source.tar.gz"
        =>
        "8de39728c7bb03be0bde0d506acc827bea732eddb7bb46892027b777b10dab27"
    ),
]

script = raw"""
cd $WORKSPACE/srcdir

mkdir build
cd build
CMAKE_ARGS="-DCMAKE_FIND_ROOT_PATH="$prefix" -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE="$CMAKE_TARGET_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release"
HELICS_ARGS="-DHELICS_BUILD_TESTS=OFF"
cmake ${CMAKE_ARGS} ${HELICS_ARGS} ..
make -j${nproc}
make install
"""

products = [
    LibraryProduct("libhelicsSharedLib", :libhelicsSharedLib),
]

platforms = [
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    MacOS(:x86_64, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    # FreeBSD(:x86_64, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Windows(:i686, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
    Windows(:x86_64, compiler_abi=CompilerABI(cxxstring_abi=:cxx11)),
]

dependencies = [
    "ZeroMQ_jll",
    "boost_jll",
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
    ; preferred_gcc_version=v"7",
)
