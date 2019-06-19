using BinaryBuilder

sources = [
    "https://github.com/gmlc-tdc/helics/archive/v2.0.0-rc1.tar.gz" => "47524ea2558961a6b924a1f972b2d063ca43daa092d91b3b8865ae06f5b33961",
    "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2" =>
    "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7",
]

script = raw"""
cd $WORKSPACE/srcdir
cd HELICS-src-2.0.0-rc1
mkdir build
cd build
cmake -DBOOST_ROOT="../../boost_1_68_0" -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j${nproc}
make install
"""

products(prefix) = [
    LibraryProduct(prefix, "libhelicsSharedLib", :libhelicsSharedLib),
]

platforms = [
             MacOS(:x86_64)
             Linux(:x86_64, compiler_abi=CompilerABI(:gcc6))
]

dependencies = []

# Build 'em!
build_tarballs(
    ARGS,
    "libhelicsSharedLib",
    v"2.0.0-rc1",
    sources,
    script,
    platforms,
    products,
    dependencies,
)

