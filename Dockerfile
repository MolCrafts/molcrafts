# syntax=docker/dockerfile:1

ARG BASE_IMAGE=ubuntu:22.04
ARG PYTHON_VERSION=3.11

FROM ${BASE_IMAGE} as base
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git && \
    rm -rf /var/lib/apt/lists/*
ENV PATH /opt/conda/bin:$PATH

FROM base as molcrafts-dev
WORKDIR /opt/molcrafts
COPY . /opt/molcrafts
RUN git submodule update --init --recursive
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libblas-dev \
        liblapack-dev  && \
    rm -rf /var/lib/apt/lists/*
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

FROM base as conda
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
