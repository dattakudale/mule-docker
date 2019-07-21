# mule-docker
Mule docker image

## Build image
docker build -t mule-esb-3.9.0:v1 .

## Run image
docker run -d mule-esb-3.9.0:v1


## Check the logs

docker logs -f <container id>