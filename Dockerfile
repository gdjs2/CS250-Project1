FROM ubuntu:focal

# Update dependency source
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
	apt-get update

# Compile symcc
WORKDIR /src
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y git cargo clang-10 cmake g++ git \
	libz3-dev llvm-10-dev llvm-10-tools ninja-build \
	python2 python3-pip zlib1g-dev libz3-dev z3 && \
	pip3 install lit

RUN git clone https://github.com/gdjs2/symcc-CS250.git symcc && \
	cd symcc && \
	git submodule init && \
	git submodule update

RUN cd symcc && \
	mkdir build && cd build && \
	cmake -G Ninja -DQSYM_BACKEND=ON -DZ3_TRUST_SYSTEM_VERSION=on .. && \
	ninja
	
# Compile Fuzzing Helper
RUN	cd symcc/util/symcc_fuzzing_helper/ && \
	cargo build --release

# Compile symqemu
RUN	apt-get build-dep -y qemu

RUN git clone https://github.com/gdjs2/symqemu-CS250.git symqemu && \
	cd symqemu && mkdir build && cd build && \
	../configure                                                    \
      --audio-drv-list= \
      --disable-bluez \
      --disable-sdl \
      --disable-gtk \
      --disable-vte \
      --disable-opengl \
      --disable-virglrenderer \
      --disable-werror \
      --target-list=x86_64-linux-user \
      --enable-capstone=git \
      --symcc-source=/src/symcc \
      --symcc-build=/src/symcc/build && \
	make -j

# Compile AFL++
RUN apt-get install -y build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo libgtk-3-dev && \
	apt-get install -y lld-12 llvm-12 llvm-12-dev clang-12 || sudo apt-get install -y lld llvm llvm-dev clang && \
	apt-get install -y gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev && \
	apt-get install -y ninja-build

RUN git clone https://github.com/gdjs2/AFLplusplus-CS250.git AFLplusplus && \
	cd AFLplusplus && \
	make distrib

WORKDIR /workdir