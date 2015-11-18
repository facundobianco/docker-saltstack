# Docker container for SaltStack 8.1

This docker installs the last stable version (2015.8.1) of SaltStack.

### Plus

* Installs master and minion.
* Configure minion.
* Installs [mg](http://homepage.boetes.org/software/mg) instead of vi.
* You can define which version of SaltStack should be installed.

## How to use this container

On this directory, build and lauch the container

```
docker build -t saltstack .
docker run -d --name saltstack saltstack
```

Connect to container

```
docker exec -it saltstack /bin/bash
```

## SaltStack first steps

Inside the container, accept the minion's request

```
salt-key -yA
```

Test it

```
salt 'minion' test.ping
```
