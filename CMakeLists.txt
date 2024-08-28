cmake_minimum_required(VERSION 3.20.0)

# The name of the project, and what languages we're using, are defined here.
project(standalone-dialect LANGUAGES CXX C)

set(CMAKE_BUILD_WITH_INSTALL_NAME_DIR ON)

set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard to conform to")

# CMAKE_SOURCE_DIR: the path to the top level directory of the project being built.
# CMAKE_CURRENT_SOURCE_DIR: the path to this directory.
# If this file is the top level being built, we'll take the first branch.
# This will make sure LLVM, MLIR, and TableGen are imported so we can use them.
# The other branch is taken if this project is only part of a larger project.
# For the MLIR Practice repo, we will always end up taking the first branch.
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Finds and loads the CMake package for MLIR.
  find_package(MLIR REQUIRED CONFIG)

  # The MLIR_DIR and LLVM_DIR variables will be set when MLIR is loaded.
  message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")
  message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

  # Create some additional useful variables.
  set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/bin)
  set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)
  set(MLIR_BINARY_DIR ${CMAKE_BINARY_DIR})

  # Append to the CMAKE_MODULE_PATH variable (which is a list of paths).
  list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
  list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")

  # Imports some useful CMake functions for working with TableGen, LLVM, and MLIR.
  include(TableGen)
  include(AddLLVM)
  include(AddMLIR)
  include(HandleLLVMOptions)
else()
  # Build via external projects mechanism
  set(MLIR_MAIN_SRC_DIR ${LLVM_MAIN_SRC_DIR}/../mlir)
  set(MLIR_INCLUDE_DIR ${MLIR_MAIN_SRC_DIR}/include)
  set(MLIR_GENERATED_INCLUDE_DIR ${LLVM_BINARY_DIR}/tools/mlir/include)
  set(MLIR_INCLUDE_DIRS "${MLIR_INCLUDE_DIR};${MLIR_GENERATED_INCLUDE_DIR}")
endif()

# Only build the Python bindings if asked to.
if(MLIR_ENABLE_BINDINGS_PYTHON)
  include(MLIRDetectPythonEnv)
  mlir_configure_python_dev_packages()
endif()

set(STANDALONE_SOURCE_DIR ${PROJECT_SOURCE_DIR})
set(STANDALONE_BINARY_DIR ${PROJECT_BINARY_DIR})

# Add some paths to search through when using a "#include" directive.
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})
include_directories(${STANDALONE_SOURCE_DIR}/include)
include_directories(${STANDALONE_BINARY_DIR}/include)

# Add a path to use for the linking step of compilation.
link_directories(${LLVM_BUILD_LIBRARY_DIR})

# Adds some additional definitions for compiler options.
add_definitions(${LLVM_DEFINITIONS})

# All of these subdirectories have additional CMakeLists.txt files
# which need to be run for the build.
# The Python libraries are only built if we specifically ask for them, though.
add_subdirectory(include)
add_subdirectory(lib)
if(MLIR_ENABLE_BINDINGS_PYTHON)
  message(STATUS "Enabling Python API")
  add_subdirectory(python)
endif()
add_subdirectory(test)
add_subdirectory(standalone-opt)
add_subdirectory(standalone-plugin)
add_subdirectory(standalone-translate)
