FROM debian:bullseye AS base

RUN apt-get update

RUN apt-get -y install git g++ make
RUN apt-get -y install libfftw3-dev libopenblas-dev libsuitesparse-dev
RUN apt-get -y install lua5.2 liblua5.2-dev

WORKDIR /usr/local/lib/
RUN git clone https://github.com/victorliu/S4.git && \
	cd S4 && \
	make && mv ./build/S4 /usr/local/bin/S4

FROM base AS parallel
RUN apt-get -y install parallel
ENTRYPOINT ["sh"]

FROM base AS default
ENTRYPOINT ["S4"]
