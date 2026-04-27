FROM ubuntu:24.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies needed for vdpm and building packages
RUN apt-get update && apt-get install -y \
    wget \
    git \
    cmake \
    make \
    patch \
    libarchive-tools \
    libtool-bin \
    xutils-dev \
    subversion \
    libc6-dev-i386 \
    python3 \
    python3-pip \
    7zip \
    sudo \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    tk-dev \
    libffi-dev \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y python3.11 python3.11-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python 2.7 from source
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz \
    && tar -xf Python-2.7.18.tar.xz \
    && cd Python-2.7.18 \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf Python-2.7.18*

# Clone and install VitaSDK
# We use the existing bootstrap-vitasdk.sh logic
RUN git clone --depth=1 https://github.com/vitasdk/vdpm.git /vdpm \
    && cd /vdpm \
    && bash bootstrap-vitasdk.sh \
    && rm -rf /vdpm

# Set environment variables
ENV VITASDK=/usr/local/vitasdk
ENV PATH=$VITASDK/bin:$PATH

WORKDIR /workspace
