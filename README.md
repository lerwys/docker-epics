Dockerfile
==========

This repository contains dockerfiles to package EPICS
into a docker image.

The following hierarchy was built:

* EPICS base

```bash
docker build -t lerwys/epics_base -f Dockerfile.epics_base .
```

* EPICS edm

```bash
docker build -t lerwys/epics_edm -f Dockerfile.epics_edm .
```

* EPICS modules

```bash
docker build -t lerwys/epics_modules -f Dockerfile.epics_modules .
```

Another option is to use the Makefile:

```bash
make
```

This will build all the images.

How to run
==========

In order to run an image interactively:

```bash
docker run --rm -it --name test --network host lerwys/<IMAGE_NAME> bash
```

In order to run the EPICS EDM image you can do:

```bash
xhost local:root
docker run --rm -it --name epics_edm --network="host" -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority lerwys/epics_edm:3.15.5
```
