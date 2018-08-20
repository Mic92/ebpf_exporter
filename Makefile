RELEASE := $(shell git describe --tags --always --dirty=-dev | sed s'/^v//g')

RELEASES_DIR := release

RELEASE_AMD64_DIR := ebpf_exporter-$(RELEASE)
RELEASE_AMD64_BINARY := $(RELEASES_DIR)/$(RELEASE_AMD64_DIR)/ebpf_exporter

.PHONY: release-binaries
release-binaries:
	rm -rf $(RELEASES_DIR)/*
	mkdir -p $(RELEASES_DIR)/$(RELEASE_AMD64_DIR)
	docker build -t ebpf-exporter-build .
	docker run --rm --entrypoint cat ebpf-exporter-build /go/bin/ebpf_exporter > $(RELEASE_AMD64_BINARY)
	chmod +x $(RELEASE_AMD64_BINARY)
	cd $(RELEASES_DIR) && tar -czf $(RELEASE_AMD64_DIR).tar.gz $(RELEASE_AMD64_DIR)
	cd $(RELEASES_DIR) && shasum -a 256 *.tar.gz > sha256sums.txt
