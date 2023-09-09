##############################################################################
# Build S4
##############################################################################
FROM debian:bullseye as build

RUN apt-get update

RUN apt-get install -y \
	libfftw3-dev \
	liblua5.2-dev \
	libopenblas-dev \
	libsuitesparse-dev \
	lua5.2

RUN apt-get install -y g++ git make

WORKDIR /usr/local/lib/
RUN git clone https://github.com/victorliu/S4.git && \
	cd S4 && \
	make

##############################################################################
# Run S4
##############################################################################
FROM debian:bullseye AS production

RUN apt-get update

RUN apt-get install -y \
	libfftw3-dev \
	liblua5.2-dev \
	libopenblas-dev \
	libsuitesparse-dev \
	lua5.2

COPY --from=build /usr/local/lib/S4/build/S4 /usr/local/bin/S4

ENV S4_DATA=/var/lib/S4/
RUN mkdir -p "$S4_DATA"
WORKDIR /var/lib/S4/
VOLUME /var/lib/S4/models

ENTRYPOINT ["S4"]
