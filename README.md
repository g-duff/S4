# S4

Example S4 Scripts

## Docker

Build: `docker build --tag s4 --file ./docker/Dockerfile .`

Run: `docker run -it --rm --mount type=bind,source=./models,target=/models s4 /models/grating.lua`
