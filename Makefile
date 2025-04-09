EPICS_VERSION ?= 7.0.7
REMOTE_NAMESPACE ?= docker.io
CONTAINER_CMD ?= podman
CMDSEP = ;

DOCKERIMAGES = epics_base \
			   epics_modules \
			   epics_env

GIT_COMMIT = $(git rev-parse --short HEAD)
TAGS = $(patsubst %, .%.tag, $(DOCKERIMAGES))
RTAGS = $(patsubst %, .%.rtag, $(DOCKERIMAGES))

all: $(TAGS) $(RTAGS)

.%.tag: Dockerfile.%
	$(CONTAINER_CMD) build \
		-t lerwys/$*:$(EPICS_VERSION) \
		-t lerwys/$*:latest \
		--build-arg EPICS_VERSION=$(EPICS_VERSION) \
		--build-arg VCS_REF=$(GIT_COMMIT) \
		--build-arg BUILD_VERSION=$(GIT_COMMIT) \
		-f $< \
		.
	touch $@

.%.rtag: .%.tag
	$(CONTAINER_CMD) tag lerwys/$*:$(EPICS_VERSION) ${REMOTE_NAMESPACE}/lerwys/$*:$(EPICS_VERSION)
	$(CONTAINER_CMD) tag lerwys/$*:latest ${REMOTE_NAMESPACE}/lerwys/$*:latest

push: $(RTAGS)
	$(foreach tag, $(patsubst .%.rtag, %, $(RTAGS)), \
		$(CONTAINER_CMD) push $(REMOTE_NAMESPACE)/lerwys/$(tag):latest $(CMDSEP))
	$(foreach tag, $(patsubst .%.rtag, %, $(RTAGS)), \
		$(CONTAINER_CMD) push $(REMOTE_NAMESPACE)/lerwys/$(tag):$(EPICS_VERSION) $(CMDSEP))

.epics_modules.tag: .epics_base.tag
.epics_feed.tag: .epics_modules.tag

clean:
	rm -f $(TAGS) $(RTAGS)
