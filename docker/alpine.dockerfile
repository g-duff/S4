FROM alpine:3.18

RUN apk add git g++ make

RUN apk add lua5.2 lua5.2-dev
RUN apk add fftw-dev openblas-dev suitesparse-dev

## Link to the library location in the makefile
RUN ln -s liblua-5.2.so.0 /usr/lib/liblua5.2.so
RUN ln -s libopenblas.so /usr/lib/libblas.so

WORKDIR /usr/local/lib/
RUN git clone https://github.com/victorliu/S4.git && \
 	cd S4 && \
 	make && \
	ln -s /usr/local/lib/S4/build/S4 /usr/local/bin/S4

ENV S4_DATA=/var/lib/S4/
RUN mkdir -p "$S4_DATA"
VOLUME /var/lib/S4/models

WORKDIR /var/lib/S4/
ENTRYPOINT ["S4"]
