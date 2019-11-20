#!/bin/bash
set -e
cd $(dirname "$0")
VERSION=$3
FILE_NAME="appsody-$VERSION-windows.tar.gz"
FILE_POSTFIX="windows"
CMD_NAME=$2
CMD_NAME=${CMD_NAME%.*}
# Create the binaries tar.gz file
cp ../$2 .
cp ../LICENSE .
cp ../README.md .
tar cfz $FILE_NAME $2 appsody-setup.bat LICENSE README.md

mv $FILE_NAME $1/
#
# Create the Windows installer EXE
#
# This only works on Travis, so we'll skip on local
if [[ "$OSTYPE" == "linux"* ]]; then

# Untar nsis compiler

tar -xvf /tmp/nsis-3.04-src.tar.bz2
# Untar nsis Stubs and Plugins
tar -xvf /tmp/nsis-3.04.tar
# Untar scons
tar -xvf /tmp/scons-3.1.1.tar.gz
# Build scons
cd scons-3.1.1 && python setup.py install
cd ..
# Build nsis
cd /nsis-3.04-src && scons SKIPSTUBS=all SKIPPLUGINS=all SKIPUTILS=all SKIPMISC=all NSIS_CONFIG_CONST_DATA=no PREFIX=/nsis-3.04-src install-compiler
# Fix dir structure and links
mkdir -p ./nsis-3.04-src/share/nsis && cd ./nsis-3.04-src/share/nsis && ln -s ./nsis-3.04-src/Contrib/ Contrib && ln -s ./nsis-3.04-src/Include/ Include && ln -s ./nsis-3.04/Stubs/ Stubs && ln -s ./nsis-3.04/Plugins/ Plugins
# Run nsis
cd ../../bin
./makensis ../../appsody.nsi
# Copy the output
cd ../..
cp appsody_installer.exe $1/
fi
rm $2 LICENSE README.md

cd ..