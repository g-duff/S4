# S4

Example S4 Scripts

## Run

Eg `S4 ./models/grating.lua`

## Docker

Build: `docker build --tag s4 --file ./docker/Dockerfile .`

Run: `docker run -it --rm --mount type=bind,source=./models,target=/models s4 /models/grating.lua`

## Install

```sh
sudo apt-get update
sudo apt-get -y install git g++ make lua5.2 liblua5.2-dev libfftw3-dev libopenblas-dev libsuitesparse-dev
```

Download the code and compile `git clone https://github.com/victorliu/S4.git && cd S4 && make`

Run in S4 directory `./build/S4 /path/to/grating.lua`
