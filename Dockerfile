FROM ubuntu:16.04

MAINTAINER Niraj Khanal <niraj.khanal@live.com>
ENV ERLANG_VERSION 20.0
ENV ELIXIR_VERSION 1.3.2

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL="en_US.UTF-8"

RUN apt-get update && apt-get install -y locales apt-utils && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get update && apt-get install -y --no-install-recommends   \
       wget                 \
       realpath             \
       build-essential      \
       checkinstall         \
       git-core             \
       curl                 \
       mc                   \
       autoconf             \
       automake             \
       vim                  \
       make                 \
       libncurses5-dev      \
       openssl              \
       libssl-dev           \
       libpng-dev           \
       libpng3              \
       graphviz             \
       gnuplot              \
       libncurses5-dev      \
       tk-dev               \
       python-dev           \
       tcl8.5-dev           \
       tk8.5-dev            \
       python3-dev          \
       xsltproc             \
       java-common          \
       default-jre          \
       default-jdk          \
       unzip                \
       ssh                  \
       unixodbc-dev         \
       uuid-runtime         \
       docker.io

# Define working directory
WORKDIR /root

# install Erlang
RUN \
    wget http://www.erlang.org/download/otp_src_${ERLANG_VERSION}.tar.gz && \
    tar -xf otp_src_${ERLANG_VERSION}.tar.gz && \
    cd otp_src_${ERLANG_VERSION} && \
    export ERL_TOP=`pwd` && \
    ./configure --with-ssl --with-javac --without-wx && \
    make && \
    make install && \
    cd .. && \
    rm otp_src_${ERLANG_VERSION}.tar.gz && \
    rm -rf otp_src_${ERLANG_VERSION}

# install Elixir
RUN \
    wget https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.zip && \
    unzip v${ELIXIR_VERSION}.zip && \
    cd elixir-${ELIXIR_VERSION} && \
    make install && \
    cd .. && \
    rm -rf elixir* && \
    rm v${ELIXIR_VERSION}.zip

RUN iex --version

ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034
# docker
RUN curl -sSL https://get.docker.com | sh
# fetch DIND script
RUN curl -sSL https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind -o /usr/local/bin/dind \
    && chmod a+x /usr/local/bin/dind

COPY ./wrapper.sh /usr/local/bin/wrapper.sh
RUN chmod a+x /usr/local/bin/wrapper.sh

VOLUME /var/lib/docker
ENTRYPOINT []
CMD []
