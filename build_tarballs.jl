using BinaryBuilder

# Collection of sources required to build p7zip
sources = [
    "https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fp7zip%2Ffiles%2Fp7zip%2F16.02%2Fp7zip_16.02_src_all.tar.bz2%2Fdownload&ts=1524045807" =>
    "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
tar xjvf p7zip*
cd p7zip_16.02
sed -i 's/\usr\/local/$WORKSPACE\/destdir/g' install.sh
mv makefile.linux_amd64 makefile.linux
make 7z
./install.sh
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.Linux(:powerpc64le, :glibc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "7z", :lib7z),
    LibraryProduct(prefix, "Rar", :librar),
    ExecutableProduct(prefix, "", :p7zip)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "p7zip", sources, script, platforms, products, dependencies)

