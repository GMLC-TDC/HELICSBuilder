using BinaryBuilder

HELICS_VERSION = v"2.4.2"
HELICS_SHA = "957856f06ed6d622f05dfe53df7768bba8fe2336d841252f5fac8345070fa5cb"

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
CMAKE_ARGS="-DCMAKE_FIND_ROOT_PATH="${prefix}" -DCMAKE_INSTALL_PREFIX=${prefix} -DCMAKE_TOOLCHAIN_FILE="$CMAKE_TARGET_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release"
HELICS_ARGS="-DHELICS_BUILD_TESTS=OFF"
cmake ${CMAKE_ARGS} ${HELICS_ARGS} ..
make -j${nproc}
make install
if [[ "${target}" == *-mingw* ]]; then
    # Remove a broken link that we don't need anyway
    rm ${prefix}/bin/libzmq.dll.a
fi
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
