#!/bin/bash

# CaPTk Packager
# Cmake command to run from /trunk/bin
# We need this directory structure for appimages to be generated
CAPTK_CMD () {
# export CMAKE_PREFIX_PATH="${TRAVIS_BUILD_DIR}/bin/qt/5.12.1/lib/cmake/Qt5:${TRAVIS_BUILD_DIR}/bin/qt/5.12.1/bin:$CMAKE_PREFIX_PATH"
# export CMAKE_PROGRAM_PATH="${TRAVIS_BUILD_DIR}/bin/qt/5.12.1/lib/cmake/Qt5:${TRAVIS_BUILD_DIR}/bin/qt/5.12.1/bin:$CMAKE_PROGRAM_PATH"
# export PATH="${TRAVIS_BUILD_DIR}/bin/qt/5.12.1/lib/cmake/Qt5:${TRAVIS_BUILD_DIR}/bin/qt/5.12.1/bin:$PATH"

export CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
export CMAKE_PREFIX_PATH="/Library/TeX/texbin"
cmake ../ -DCMAKE_INSTALL_PREFIX="${TRAVIS_BUILD_DIR}/bin/install"
cmake ../ -DCMAKE_INSTALL_PREFIX="${TRAVIS_BUILD_DIR}/bin/install"

echo "Run Dependency Manager"
# # make & sleep 5600; kill $! 
make -j 2

rm CMakeCache.txt

export CC=/usr/local/opt/llvm/bin/clang
export CXX=/usr/local/opt/llvm/bin/clang++
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-L/usr/local/opt/llvm/include"

echo "Run CaPTk Build"
# export CMAKE_PREFIX_PATH="${TRAVIS_BUILD_DIR}/bin/install/lib/cmake/ITK-4.13:$CMAKE_PREFIX_PATH"
cmake ../
cmake ../

make -j 2

make package

# chmod +x ../.travis/mac-pkg.sh
# ../.travis/mac-pkg.sh
}

###########################
echo "[!] Warn: This script is intended for CI use. Only use it if you know what you are doing."

echo "[:] Starting CaPTk packaging process..."

echo "[?] Checking if you are in trunk..."
# Test to see if the user is in trunk
# First see if CMakeLists.txt exists
if [[ -e CMakeLists.txt ]] ; then
# See if it contains PROJECT( CaPTk )
if [[ -z `cat CMakeLists.txt | grep "PROJECT( CaPTk )"` ]] ; then
echo "[!] Error: You do not appear to be within trunk of CaPTk (Project is not CaPTk)"
exit -1
fi
else
echo "[!] Error: You do not appear to be in trunk (CMakeLists.txt not found)"
exit -1
fi

# Nuclear option
rm -rf history
rm -rf src/applications/individualApps/libra/MCRInstaller.zip

# Create binary directory
echo "[:] Creating binary directory..."
mkdir -p bin

# Move externalApps into bin to trick CMake
mv ${TRAVIS_BUILD_DIR}/binaries/externalApps.zip ./bin/

cd bin

# Extract externalApps
unzip externalApps.zip &> /dev/null

# Create test data dir to skip ftp download
mkdir testing
mkdir ./testing/TestData

# Cmake
echo "[:] Running cmake command and build CaPTk..."
CAPTK_CMD

echo "[:] Done. Built test target"
