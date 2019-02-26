using BinaryBuilder

sources = [
    "https://github.com/gmlc-tdc/helics-src/archive/v2.0.0-rc1.tar.gz" => "47524ea2558961a6b924a1f972b2d063ca43daa092d91b3b8865ae06f5b33961"
]

script = raw"""
cd $WORKSPACE/srcdir
cd HELICS-src-2.0.0-rc1
mkdir build
cd build
cmake -DZMQ_USE_STATIC_LIBRARY=ON -DAUTOBUILD_ZMQ=ON -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make
make install
"""

products(prefix) = [
    LibraryProduct(prefix, "libhelicsSharedLib", :libhelicsSharedLib),
]

platforms = [
             Linux(:x86_64, compiler_abi=CompilerABI(:gcc6))
]

dependencies = [
               "https://github.com/kdheepak/boostBuilder/releases/download/v1.69.0/build_Boost.v1.69.0.jl"
              ]

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

