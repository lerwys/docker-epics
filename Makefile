EPICS_VERSION ?= 7.0.7
REMOTE_NAMESPACE ?= docker.io
CMDSEP = ;

DOCKERIMAGES = epics_base \
			   epics_modules

TAGS = $(patsubst %, .%.tag, $(DOCKERIMAGES))
RTAGS = $(patsubst %, .%.rtag, $(DOCKERIMAGES))

all: $(TAGS) $(RTAGS)

.%.tag: Dockerfile.%
	DOCKER_BUILDKIT=1 docker build \
		-t lerwys/$*:$(EPICS_VERSION) \
		-t lerwys/$*:latest \
		--build-arg EPICS_VERSION=$(EPICS_VERSION) \
		--build-arg BUILD_VERSION=0.0.1 \
		-f $< \
		.
	touch $@

.%.rtag: .%.tag
	docker tag lerwys/$*:$(EPICS_VERSION) ${REMOTE_NAMESPACE}/lerwys/$*:$(EPICS_VERSION)
	docker tag lerwys/$*:latest ${REMOTE_NAMESPACE}/lerwys/$*:latest

push: $(RTAGS)
	$(foreach tag, $(patsubst .%.rtag, %, $(RTAGS)), \
		docker push $(REMOTE_NAMESPACE)/lerwys/$(tag):latest $(CMDSEP))
	$(foreach tag, $(patsubst .%.rtag, %, $(RTAGS)), \
		docker push $(REMOTE_NAMESPACE)/lerwys/$(tag):$(EPICS_VERSION) $(CMDSEP))

.epics_modules.tag: .epics_base.tag
.epics_feed.tag: .epics_modules.tag

clean:
	rm -f $(TAGS) $(RTAGS)
