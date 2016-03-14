# Dockerfile to build a Docker image with the latest Swift binaries and its
# dependencies.

FROM ubuntu:14.04
MAINTAINER superpan
LABEL Description="Linux Ubuntu image with the latest Swift binaries."

# Set environment variables for image
ENV SWIFT_SNAPSHOT swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a
ENV UBUNTU_VERSION ubuntu14.04
ENV UBUNTU_VERSION_NO_DOTS ubuntu1404
ENV HOME /opt
ENV WORK_DIR /opt
#ENV LD_LIBRARY_PATH=/usr/local/lib

# Set WORKDIR
WORKDIR ${WORK_DIR}

# Linux OS utils
RUN apt-get update
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y gcc-4.8
RUN apt-get install -y g++-4.8
RUN apt-get install -y libcurl3
RUN apt-get install -y libkqueue-dev
RUN apt-get install -y openssh-client
RUN apt-get install -y automake
RUN apt-get install -y libbsd-dev
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y libtool
RUN apt-get install -y clang
RUN apt-get install -y curl
RUN apt-get install -y libglib2.0-dev
RUN apt-get install -y libblocksruntime-dev
RUN apt-get install -y libicu52
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y telnet

# Install dependencies
RUN apt-get install -y libhttp-parser-dev

# Install Swift compiler
RUN wget https://swift.org/builds/development/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
RUN tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
ENV PATH $WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH
RUN swiftc -h

# Clone and install swift-corelibs-libdispatch
RUN git clone https://github.com/apple/swift-corelibs-libdispatch.git
RUN cd swift-corelibs-libdispatch && git submodule init && git submodule update && sh ./autogen.sh && ./configure --with-swift-toolchain=$WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr --prefix=$WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr && make && make install
