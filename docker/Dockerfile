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

ENTRYPOINT ["S4"]
