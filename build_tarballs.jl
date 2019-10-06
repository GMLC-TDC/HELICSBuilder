using BinaryBuilder

sources = [
    "https://github.com/GMLC-TDC/HELICS/releases/download/v2.2.1/Helics-v2.2.1-source.tar.gz" => "bd78405337aa416aedb1ba9582d4ea3c6e8a9da4918217ff35faaa2f4a63a239",
]

script = raw"""
cd $WORKSPACE/srcdir
mkdir build
cd build

# On windows platforms, our ./configure and make invocations differ a bit
if [[ ${target} == *-w64-mingw* ]]; then
    EXTRA_CMAKE_FLAGS=""
fi

cat /opt/$target/$target.toolchain

cat ${CMAKE_TARGET_TOOLCHAIN}

cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_BUILD_TYPE=Release -DBUILD_HELICS_BOOST_TESTS=OFF -DBUILD_HELICS_TESTS=OFF ..
make -j${nproc}
make install
"""

products(prefix) = [
    LibraryProduct(prefix, "libhelicsSharedLib", :libhelicsSharedLib),
]

platforms = supported_platforms()

dependencies = [
                "https://github.com/benlorenz/boostBuilder/releases/download/v1.71.0/build_boost.v1.71.0.jl",
                "https://github.com/JuliaInterop/ZMQBuilder/releases/download/v4.2.5%2B6/build.jl",
]

# Build 'em!
build_tarballs(
    ARGS,
    "libhelicsSharedLib",
    v"2.2.1",
    sources,
    script,
    platforms,
    products,
    dependencies,
)

