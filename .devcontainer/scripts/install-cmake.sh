wget https://github.com/Kitware/CMake/releases/download/v3.30.1/cmake-3.30.1-linux-x86_64.sh

chmod +x cmake-3.30.1-linux-x86_64.sh
sudo ./cmake-3.30.1-linux-x86_64.sh --prefix=/usr/local --exclude-subdir
rm cmake-3.30.1-linux-x86_64.sh