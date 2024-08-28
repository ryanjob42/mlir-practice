#!/bin/bash

# These commands are slightly modified from LLVM's standalone MLIR example.
# https://github.com/llvm/llvm-project/tree/main/mlir/examples/standalone

# Make sure we ahve the correct version of GCC.
module purge
module load gcc/7.4.0

# Create the build directory.
mkdir -p build
cd build

# Configure the CMake build.
# Note: we're using slightly different environment variables.
# Also note: instead of requiring that LLVM/MLIR gets installed,
# we're referencing its build directory.
cmake -G Ninja .. \
    -DMLIR_DIR=$LLVM_BUILD_DIR/lib/cmake/mlir \
    -DLLVM_EXTERNAL_LIT=$LLVM_BUILD_DIR/bin/llvm-lit

# Run the CMake build.
cmake --build . --target check-standalone
