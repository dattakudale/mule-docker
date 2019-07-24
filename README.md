# mule-docker
Mule docker image version 4.1.1

## Build image
docker build -t mule-esb-4.1.1:latest .

## Run image
docker run -d mule-esb-4.1.1:latest


## Check the logs

```
docker logs -f <containerid>
```

# Openshift creating custom image

```
oc login -u developer -p developer

oc new-project mule-esb --description="Testing Mule ESB" --display-name="Mule ESB project"
oc create imagestream mule-esb-4.1.1
```

## Create Build in openshift and trigger.
```
oc create -f kubernete-build.yaml
```

## After creating image deploy the app

```
oc create -f kubernete-deploy.yaml
```
