FROM ubuntu:24.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user for building
RUN useradd -m vita

# Install sudo first and separately to avoid dependency issues in Docker
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends sudo && \
    echo "vita ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies needed for vdpm and building packages
RUN apt-get update && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then LIBC32="libc6-dev-i386 gcc-multilib"; else LIBC32=""; fi && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    cmake \
    meson \
    ninja-build \
    make \
    patch \
    fakeroot \
    libarchive-tools \
    libtool-bin \
    xutils-dev \
    subversion \
    $LIBC32 \
    python3 \
    python3-pip \
    nodejs \
    7zip \
    build-essential \
    autoconf \
    automake \
    autotools-dev \
    m4 \
    libtool \
    pkg-config \
    gperf \
    bison \
    flex \
    gettext \
    linux-libc-dev \
    libssl-dev \
    unzip \
    zlib1g-dev \
    libncurses-dev \
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
    && apt-get update && apt-get install -y --no-install-recommends python3.11 python3.11-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python 2.7 from source
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz \
    && tar -xf Python-2.7.18.tar.xz \
    && cd Python-2.7.18 \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf Python-2.7.18*

# Clone and install VitaSDK using exact core snapshot or development bootstrap
ARG VITASDK_CACHE_BUST
ARG CORE_SNAPSHOT
ARG VDPM_REF=master
RUN echo "VitaSDK Cache Bust: $VITASDK_CACHE_BUST" && \
    if [ -n "$CORE_SNAPSHOT" ]; then \
        echo "Installing VitaSDK from exact core snapshot: $CORE_SNAPSHOT" && \
        mkdir -p /tmp/vitasdk-bootstrap && \
        cd /tmp/vitasdk-bootstrap && \
        bootstrap_url="https://github.com/vitasdk/autobuilds/releases/download/${CORE_SNAPSHOT}/vitasdk-bootstrap-x86_64-linux-gnu.tar.bz2" && \
        wget -q "$bootstrap_url" -O bootstrap.tar.bz2 || { echo "Failed to download $bootstrap_url"; exit 1; } && \
        if ! wget -q "${bootstrap_url}.sha256" -O bootstrap.tar.bz2.sha256; then \
            echo "No .sha256 sidecar, reading the release SHA256SUMS instead" && \
            wget -q "${bootstrap_url%/*}/SHA256SUMS" -O SHA256SUMS || { echo "Failed to download SHA256SUMS"; exit 1; }; \
            awk -v archive="${bootstrap_url##*/}" '{ sub(/^\*/, "", $2) } $2 == archive { print $1 }' \
                SHA256SUMS > bootstrap.tar.bz2.sha256; \
        fi && \
        expected_sha=$(awk '{print $1}' bootstrap.tar.bz2.sha256) && \
        if [ -z "$expected_sha" ]; then \
            echo "No checksum published for ${bootstrap_url##*/} in $CORE_SNAPSHOT"; exit 1; \
        fi && \
        actual_sha=$(sha256sum bootstrap.tar.bz2 | awk '{print $1}') && \
        if [ "$expected_sha" != "$actual_sha" ]; then \
            echo "Checksum mismatch for core snapshot $CORE_SNAPSHOT: expected $expected_sha, got $actual_sha"; exit 1; \
        fi && \
        git clone --depth=1 --branch "$VDPM_REF" https://github.com/vitasdk/vdpm.git /vdpm && \
        VITASDK_BOOTSTRAP_ARCHIVE=/tmp/vitasdk-bootstrap/bootstrap.tar.bz2 \
        VITASDK_BOOTSTRAP_SHA256="$actual_sha" \
        bash /vdpm/bootstrap-vitasdk.sh --install-dir /usr/local/vitasdk && \
        rm -rf /vdpm /tmp/vitasdk-bootstrap ; \
    else \
        echo "Installing VitaSDK using development branch: $VDPM_REF" && \
        git clone --depth=1 --branch "$VDPM_REF" https://github.com/vitasdk/vdpm.git /vdpm && \
        cd /vdpm && \
        bash bootstrap-vitasdk.sh && \
        rm -rf /vdpm ; \
    fi

# Set environment variables
ENV VITASDK=/usr/local/vitasdk
ENV PATH=$VITASDK/bin:$PATH

# Ensure the non-root user owns the vitasdk directory
RUN chown -R vita:vita /usr/local/vitasdk

USER vita
WORKDIR /workspace
