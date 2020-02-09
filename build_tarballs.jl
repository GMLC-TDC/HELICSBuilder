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
    Linux(:x86_64, libc=:glibc),
    Linux(:x86_64, libc=:musl),
    MacOS(:x86_64),
    Windows(:x86_64),
] |> expand_cxxstring_abis

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
    ; preferred_gcc_version=v"7",
)
