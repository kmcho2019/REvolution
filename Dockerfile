# 1. Use a standard, well-maintained base image to match the original environment
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# 2. Install base dependencies, build tools, and git
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    cmake \
    git \
    libreadline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    qtcreator \
    qtbase5-dev \
    qt5-qmake \
    libqt5svg5-dev \
    wget \
    curl \
    flex \
    autoconf \
    gperf \
    pkg-config \
    libboost-system-dev \
    libboost-python-dev \
    libboost-filesystem-dev \
    zlib1g-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# 2.1 Install bison 3.5 to avoid issues with verilator
RUN apt-get purge -y bison || true

RUN wget -q https://ftp.gnu.org/gnu/bison/bison-3.5.4.tar.xz && \
    tar -xf bison-3.5.4.tar.xz && \
    cd bison-3.5.4 && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf bison-3.5.4 bison-3.5.4.tar.xz


# 3. Install Icarus Verilog (v12_0)
RUN git clone https://github.com/steveicarus/iverilog.git /tmp/iverilog && \
    cd /tmp/iverilog && \
    git checkout v12_0 && \
    sh autoconf.sh && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/iverilog

# 4. Install Yosys(0.54+29, git sha1 7b0c1fe49) (Matching specific commit from original image)
RUN git clone --recurse-submodules https://github.com/YosysHQ/yosys.git /tmp/yosys && \
    cd /tmp/yosys && \
    git checkout 7b0c1fe49 && \
    git submodule update --init --recursive && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/yosys

# 5. Install OpenROAD (v2.0-22560-gb571c4b471)
RUN git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD.git /tmp/OpenROAD && \
    cd /tmp/OpenROAD && \
    git checkout b571c4b471 && \
    git submodule update --init --recursive && \
    ./etc/DependencyInstaller.sh -all && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/OpenROAD

# 6. Install Verilator (rev v4.036-114-g0cd4a57ad)
RUN git clone https://github.com/verilator/verilator.git /tmp/verilator && \
    cd /tmp/verilator && \
    git checkout 0cd4a57ad && \
    autoconf && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/verilator

# 7. Install uv for Python environment management
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    install -m 0755 /root/.local/bin/uv /usr/local/bin/uv

# 8. Set up the non-root user for security
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
# 8.5 Create workspace directory and set permissions
RUN mkdir -p /workspace && chown -R $USERNAME:$USERNAME /workspace

# 9. Set up the workspace
WORKDIR /workspace

# 10. Copy dependency definitions and python pin first to leverage Docker build cache
COPY --chown=$USERNAME:$USERNAME pyproject.toml uv.lock .python-version ./

# 11. Switch to the non-root user before installing python packages
USER $USERNAME
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"

# 12. Install third-party Python dependencies first for better layer caching
RUN uv sync --frozen --no-install-project

# 13. Copy the rest of the application source code
COPY --chown=$USERNAME:$USERNAME . .

# 14. Install the local project after source files are available
RUN uv sync --frozen

# 15. Set the default command
CMD ["/bin/bash"]
