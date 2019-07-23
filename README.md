# mule-docker
Mule docker image

## Build image
docker build -t mule-esb-3.9.0:v1 .

## Run image
docker run -d mule-esb-3.9.0:v1


## Check the logs

```
docker logs -f <containerid>
```

# Openshift creating custom image

```
oc login -u developer -p developer

oc new-project mule-esb-test --description="Testing Mule ESB" --display-name="Mule ESB project"

oc new-app https://github.com/dkudale/mule-docker.git

```

## Create Build in openshift and trigger.
```
oc create -f kubernete-build.yaml
```

## After creating image deploy the app

```
oc create -f kubernete-deploy.yaml
```
