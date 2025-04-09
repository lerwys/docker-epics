Dockerfile
==========

This repository contains dockerfiles to package EPICS
into a docker image.

The following hierarchy was built:

* EPICS base

With Docker:

```bash
docker build -t lerwys/epics_base -f Dockerfile.epics_base .
```

With Podman:

```bash
podman build -t lerwys/epics_base -f Dockerfile.epics_base .
```

* EPICS modules

With Docker:

```bash
docker build -t lerwys/epics_modules -f Dockerfile.epics_modules .
```

With Podman:

```bash
podman build -t lerwys/epics_modules -f Dockerfile.epics_modules .
```

Another option is to use the Makefile (defaults to podman):

```bash
make
```

This will build all the images.

How to run
==========

In order to run an image interactively:

With Docker:

```bash
docker run --rm -it --name epics_env --network host -v $HOME/.ssh:/home/epics/.ssh:ro lerwys/<IMAGE_NAME> bash
```

With Podman:

```bash
podman run --rm -it --name epics_env --network host --userns=keep-id -v $HOME/.ssh:/home/epics/.ssh:ro docker.io/lerwys/epics_modules bash
```
