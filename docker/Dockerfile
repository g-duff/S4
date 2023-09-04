FROM debian:bullseye

RUN apt-get update

RUN apt-get -y install git

RUN apt-get -y install g++ make

RUN apt-get -y install lua5.2 liblua5.2-dev
RUN apt-get -y install libfftw3-dev libopenblas-dev libsuitesparse-dev

WORKDIR /usr/local/lib/
RUN git clone https://github.com/victorliu/S4.git && \
	cd S4 && \
	make && mv ./build/S4 /usr/local/bin/S4

ENV S4_DATA=/var/lib/S4/
RUN mkdir -p "$S4_DATA"
VOLUME /var/lib/S4/models

WORKDIR /var/lib/S4/
ENTRYPOINT ["S4"]
