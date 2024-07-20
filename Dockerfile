# syntax=docker/dockerfile:1

ARG BASE_IMAGE=ubuntu:22.04
ARG PYTHON_VERSION=3.11

FROM ${BASE_IMAGE} AS dev-base
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        ccache \
        cmake \
        curl \
        zip \
        unzip \
        tar \
        zsh \
        libblas-dev \
        liblapack-dev \
        git && \
    rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/update-ccache-symlinks
RUN mkdir /opt/ccache && ccache --set-config=cache_dir=/opt/ccache
ENV PATH=/opt/conda/bin:$PATH

FROM dev-base AS conda
ARG PYTHON_VERSION=3.11
ARG TARGETPLATFORM
RUN case ${TARGETPLATFORM} in \
         "linux/arm64")  MINICONDA_ARCH=aarch64  ;; \
         *)              MINICONDA_ARCH=x86_64   ;; \
    esac && \
    curl -fsSL -v -o ~/miniconda.sh -O  "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${MINICONDA_ARCH}.sh"
RUN chmod +x ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y python=${PYTHON_VERSION} && \
    /opt/conda/bin/conda clean -ya

FROM dev-base AS submodule-update
WORKDIR /opt/molcrafts
COPY . .
RUN git submodule update --init --recursive

FROM conda AS molcrafts-dev
WORKDIR /opt/molcrafts
COPY --from=conda /opt/conda /opt/conda
COPY --from=submodule-update /opt/molcrafts /opt/molcrafts
RUN git clone https://github.com/microsoft/vcpkg.git && \
    cd vcpkg && \
    ./bootstrap-vcpkg.sh 
ENV VCPKG_ROOT=/opt/molcrafts/vcpkg
ENV PATH=$VCPKG_ROOT:$PATH