# MLIR Setup
This is how to set up MLIR, which is suggested (and semi-necessary) for working with MLIR.
The info and commands come from MLIR's Getting Started page, linked below.
I've made some minor changes that suit my own needs.

https://mlir.llvm.org/getting_started/

## Environment
I'm using a CS department machine at CSU for my own convenience.
The code seems to be rather picky about which compiler versions you're using.
Check the links below for what versions to install.

* https://llvm.org/docs/GettingStarted.html#software
* https://llvm.org/docs/GettingStarted.html#host-c-toolchain-both-compiler-and-standard-library

The department machines have a module for GCC 7.4 (which is the suggested version).
While using Clang and LLD is recommended, these machines don't seem to have LLD installed,
and the version of Clang available is too new and causes the build failures.

I found that using GCC 13 worked for compiling MLIR here, but it caused issues later on.
Because of this, I'd recommend sticking with 7.4.

If you're using your own machine, you may want to use a Docker image.
LLVM has a page with info about building an image, linked below.

https://llvm.org/docs/Docker.html

## Commands
The commands below will build MLIR.
Installation is not allowed on the department machines, so I'll skip that.
While it's possible to set up CMake to install somewhere else, I found it isn't necessary,
so skipping the install will keep things simple (and hopefully more reproducible).

If you're not building from the CS department machines,
you'll almost definitely need to drop the `module` commands at the beginning and end.
Other than that, everything should work anywhere.

```shell
# Make sure we have the correct version of GCC.
module purge
module load gcc/7.4.0

# Clone the repo with a depth of 1 so it's faster and takes less space.
# I personally use my Documents folder, but feel free to put it anywhere.
cd ~/Documents
git clone --depth 1 https://github.com/llvm/llvm-project.git

# Create a "build" directory to hold the compilation files.
mkdir llvm-project/build
cd llvm-project/build

# Configure the CMake build.
cmake -G Ninja ../llvm \
-DLLVM_ENABLE_PROJECTS=mlir \
-DLLVM_BUILD_EXAMPLES=ON \
-DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
-DCMAKE_BUILD_TYPE=Release \
-DLLVM_ENABLE_ASSERTIONS=ON

# Run the CMake build.
cmake --build . --target check-mlir

# Add the binaries to your path, and create some useful environment variables.
# This will add the "export" commands to the end of your .bashrc file.
# Note: the placement and types of quotes are important!
echo 'export PATH="'$(pwd)'/bin:$PATH"' >> ~/.bashrc
echo 'export LLVM_BUILD_DIR="'$(pwd)'"' >> ~/.bashrc
source ~/.bashrc

# Re-load GCC in case sourcing the .bashrc file reset it.
module purge
module load gcc/7.4.0
```