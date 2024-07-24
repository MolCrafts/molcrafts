FROM mcr.microsoft.com/devcontainers/base:ubuntu
USER root

# Install needed packages. Use a separate RUN statement to add your own dependencies.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install build-essential gdb gfortran autoconf autoconf-archive liblapack-dev libblas-dev \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Tools needed for llvm
# RUN sudo apt-get -y update
# RUN sudo apt install -y lsb-release wget software-properties-common gnupg

# Install CLANG if version is specified
# ARG CLANG_VERSION
# RUN if [ -n "$CLANG_VERSION" ]; then \
#     sudo wget https://apt.llvm.org/llvm.sh; \
#     chmod +x llvm.sh; \
#     sudo ./llvm.sh "${CLANG_VERSION}"; \
#     echo 'export CC=clang' >> ~/.bashrc; \
#     echo 'export CXX=clang++' >> ~/.bashrc; \
#     sudo apt update; \
#     sudo apt install -y clang; \
#     sudo apt install -y libomp-dev; \
#     fi

# Setup ENV vars for vcpkg
ENV VCPKG_ROOT=/usr/local/vcpkg \
    VCPKG_DOWNLOADS=/usr/local/vcpkg-downloads
ENV PATH="${PATH}:${VCPKG_ROOT}"

ARG USERNAME=vscode

# Install vcpkg itself: https://github.com/microsoft/vcpkg/blob/master/README.md#quick-start-unix
COPY scripts/install-vcpkg.sh /tmp/
RUN chmod +x /tmp/install-vcpkg.sh \
    && ./tmp/install-vcpkg.sh ${USERNAME} \
    && rm -f /tmp/install-vcpkg.sh
    
COPY scripts/install-cmake.sh /tmp/
RUN chmod +x /tmp/install-cmake.sh \
    && ./tmp/install-cmake.sh \
    && rm -f /tmp/install-cmake.sh
# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>