FROM mcr.microsoft.com/devcontainers/miniconda:3
ARG USERNAME=vscode

#  I am suprised this is needed
RUN conda init

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY .devcontainer/environment.yml .devcontainer/noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && sudo rm -rf /tmp/conda-tmp

# Tools needed for llvm
RUN sudo apt-get -y update
RUN sudo apt install -y lsb-release wget software-properties-common gnupg

# Install blas and lapack
RUN sudo apt-get install -y libblas-dev liblapack-dev

RUN sudo apt-get install -y build-essential gdb autoconf automake autoconf-archive gfortran valgrind && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install CLANG if version is specified
ARG CLANG_VERSION
RUN if [ -n "$CLANG_VERSION" ]; then \
    sudo wget https://apt.llvm.org/llvm.sh; \
    chmod +x llvm.sh; \
    sudo ./llvm.sh "${CLANG_VERSION}"; \
    echo 'export CC=clang' >> ~/.bashrc; \
    echo 'export CXX=clang++' >> ~/.bashrc; \
    sudo apt update; \
    sudo apt install -y clang flang; \
    sudo apt install -y libomp-dev; \
    fi

# Install cuda if version is specified
ARG CUDA_VERSION
RUN if [ -n "$CUDA_VERSION" ]; then \
       conda install -y cuda -c "nvidia/label/cuda-${CUDA_VERSION}"; \
    fi

# Setup ENV vars for vcpkg
ENV VCPKG_ROOT=/usr/local/vcpkg \
    VCPKG_DOWNLOADS=/usr/local/vcpkg-downloads
ENV PATH="${PATH}:${VCPKG_ROOT}"

# Install vcpkg itself: https://github.com/microsoft/vcpkg/blob/master/README.md#quick-start-unix
COPY .devcontainer/scripts/install-vcpkg.sh /tmp/
RUN chmod +x /tmp/install-vcpkg.sh \
    && ./tmp/install-vcpkg.sh ${USERNAME} \
    && rm -f /tmp/install-vcpkg.sh
