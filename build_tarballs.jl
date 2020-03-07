using BinaryBuilder

HELICS_VERSION = v"2.4.1"
HELICS_SHA = "ac077e9efe466881ea366721cb31fb37ea0e72a881a717323ba4f3cdda338be4"

sources = [
    ArchiveSource(
        "https://github.com/GMLC-TDC/HELICS/releases/download/v$HELICS_VERSION/Helics-v$HELICS_VERSION-source.tar.gz",
        "$HELICS_SHA",
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

platforms = expand_cxxstring_abis(supported_platforms(exclude = [FreeBSD(:x86_64)]))

dependencies = [
    Dependency("ZeroMQ_jll"),
    BuildDependency("boost_jll"),
]

# Build 'em!
build_tarballs(
    ARGS,
    "HELICS",
    HELICS_VERSION,
    sources,
    script,
    platforms,
    products,
    dependencies,
    ;
    preferred_gcc_version = v"7",
)
