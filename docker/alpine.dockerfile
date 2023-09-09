##############################################################################
# Build S4
##############################################################################
FROM alpine:3.18 AS build

RUN apk add fftw lua5.2 lua5.2-dev openblas-dev suitesparse-dev
RUN apk add g++ git make

## Link to the library location in the makefile
RUN ln -s liblua-5.2.so.0 /usr/lib/liblua5.2.so && ln -s libopenblas.so /usr/lib/libblas.so

WORKDIR /usr/local/lib/
RUN git clone https://github.com/victorliu/S4.git && \
 	cd S4 && \
 	make

##############################################################################
# Run S4
##############################################################################
FROM alpine:3.18 AS production

RUN apk add fftw lua5.2 lua5.2-dev openblas-dev suitesparse-dev

COPY --from=build /usr/local/lib/S4/build/S4 /usr/local/bin/S4

ENV S4_DATA=/var/lib/S4/
RUN mkdir -p "$S4_DATA"
WORKDIR /var/lib/S4/
VOLUME /var/lib/S4/models

ENTRYPOINT ["S4"]
