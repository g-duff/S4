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

RUN groupadd -r S4 --gid=999; \
	useradd -r -g S4 --uid=999 --home-dir=/var/lib/S4 --shell=/bin/bash S4; \
	mkdir -p /var/lib/S4; \
	chown -R S4:S4 /var/lib/S4

ENV S4_MODELS=/var/lib/S4/models
RUN mkdir -p "$S4_MODELS" && \
	chown -R S4:S4 "$S4_MODELS" && \
	chmod 777 "$S4_MODELS"
WORKDIR /var/lib/S4/
VOLUME /var/lib/S4/models

ENTRYPOINT ["S4"]
