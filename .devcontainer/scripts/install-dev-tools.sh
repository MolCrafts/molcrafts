#!/usr/bin/env bash
# Run this command from the PyTorch directory after cloning the source code using the “Get the PyTorch Source“ section below
pip install -r requirements.txt
git submodule sync
git submodule update --init --recursive

# Add CMAKE_PREFIX_PATH to bashrc
echo 'export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}' >> ~/.bashrc
# Add linker path so that cuda-related libraries can be found
echo 'export LDFLAGS="-L${CONDA_PREFIX}/lib/ $LDFLAGS"' >> ~/.bashrc

git clone https://github.com/Microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh
echo 'export VCPKG_ROOT=/workspaces/molcrafts/vcpkg' >> ~/.bashrc
echo 'export VCPKG_ROOT=/workspaces/molcrafts/vcpkg' >> ~/.zshrc
echo 'export PATH=$VCPKG_ROOT:$PATH' >> ~/.bashrc
echo 'export PATH=$VCPKG_ROOT:$PATH' >> ~/.zshrc