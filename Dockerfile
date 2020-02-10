FROM ubuntu:18.04

WORKDIR /setup

# Configure apt and install packages
RUN apt update \
    && apt -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, process tools installed
    && apt-get -y install git iproute2 procps \
    #
    # Install rocket-tools dependencies described here: https://github.com/chipsalliance/rocket-tools
    && apt -y install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev libfl-dev \
    #
    # Clean up
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install rocket-tools
ENV RISCV /opt/riscv-toolchain
RUN git clone https://github.com/chipsalliance/rocket-tools.git \
    && cd rocket-tools \
    && git submodule update --init --recursive \
    && ./build.sh
ENV PATH $PATH:$RISCV/bin

CMD ["bash"]
