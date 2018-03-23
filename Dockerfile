FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y build-essential git wget make libncurses-dev flex bison gperf python python-serial libcmocka0 libcmocka-dev gawk gperf grep gettext python python-dev automake bison flex texinfo help2man libtool libtool-bin
RUN mkdir -p /esp/project
WORKDIR /esp
RUN git clone -b xtensa-1.22.x https://github.com/espressif/crosstool-NG.git
WORKDIR /esp/crosstool-NG
RUN ./bootstrap
RUN ./configure --enable-local
RUN make install
RUN ./ct-ng xtensa-esp32-elf
RUN echo CT_ALLOW_BUILD_AS_ROOT=y >> .config
RUN echo CT_ALLOW_BUILD_AS_ROOT_SURE=y >> .config
RUN cat .config | grep ROOT
RUN ./ct-ng build
RUN chmod -R u+w builds/xtensa-esp32-elf
ENV PATH $PATH:/esp/xtensa-esp32-elf/bin
WORKDIR /esp
RUN git clone --recursive https://github.com/espressif/esp-idf.git
ENV IDF_PATH /esp/esp-idf
WORKDIR /esp/project
