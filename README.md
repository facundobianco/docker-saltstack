# Docker container for SaltStack 8.3

This docker installs the lastest stable version (2015.8.3) of SaltStack.

The previous container was [based on Debian 8.2](Dockerfile.deb) (118 MB) and this release is based on Alpine (91.82 MB).

## Plus

* Installs master and minion.
* Configures minion.

## How to get it

You can pull this container from Docker Hub

```
docker pull vando/saltstack
```

## Connect to container

Start the container

```
docker run -d -p 4505:4505 -p 4506:4506 --name saltstack vando/saltstack
docker exec -it saltstack sh
```

## SaltStack first steps

```
salt 'minion' test.ping
```
