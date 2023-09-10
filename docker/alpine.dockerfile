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

RUN addgroup -g 70 -S S4; \
	adduser -u 70 -S -D -G S4 -H -h /var/lib/S4 -s /bin/sh S4; \
	mkdir -p /var/lib/S4; \
	chown -R S4:S4 /var/lib/S4

ENV S4_MODELS=/var/lib/S4/models
RUN mkdir -p "$S4_MODELS" && \
	 chown -R S4:S4 "$S4_MODELS" && \
	 chmod 1777 "$S4_MODELS"
WORKDIR /var/lib/S4/
VOLUME /var/lib/S4/models

ENTRYPOINT ["S4"]
