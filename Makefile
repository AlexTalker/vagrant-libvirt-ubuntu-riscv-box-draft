.PHONY: default clean prep deps

UBUNTU_RELEASE_MAJOR ?= 24.04
UBUNTU_RELEASE_MINOR ?= .1
UBUNTU_RELEASE ?= $(UBUNTU_RELEASE_MAJOR)$(UBUNTU_RELEASE_MINOR)
# Prior to 24.04 LTS:
# UBUNTU_RELEASE_VARIANT := preinstalled-server-riscv64+unmatched
UBUNTU_RELEASE_VARIANT ?= preinstalled-server-riscv64
UBUNTU_IMG_NAME ?= ubuntu-$(UBUNTU_RELEASE)-$(UBUNTU_RELEASE_VARIANT).img
UBUNTU_IMG_COMPRESSED := $(UBUNTU_IMG_NAME).xz
UBUNTU_RELEASE_URL ?= https://cdimage.ubuntu.com/releases/$(UBUNTU_RELEASE_MAJOR)/release/$(UBUNTU_IMG_COMPRESSED)
UBUNTU_IMG_TMP := ubuntu.img
UBUNTU_IMG_QCOW := box.img
UBUNTU_BOX_NAME := ubuntu-riscv-$(UBUNTU_RELEASE).box

SUDO ?= sudo

default: $(UBUNTU_BOX_NAME)
	@echo "Successfully created vagrant-libvirt box: $(UBUNTU_BOX_NAME)"
	@echo "Completed!"

# Manually craft the Vagrant box:
# https://github.com/vagrant-libvirt/vagrant-libvirt/tree/main/example_box
$(UBUNTU_BOX_NAME): $(UBUNTU_IMG_QCOW) metadata.json Vagrantfile deps
	@tar -cvzf "$(UBUNTU_BOX_NAME)" "$(UBUNTU_IMG_QCOW)" metadata.json Vagrantfile

metadata.json: $(UBUNTU_IMG_QCOW) deps
	@python helpers/gen-metadata-json.py "$(UBUNTU_IMG_QCOW)"

$(UBUNTU_IMG_QCOW): $(UBUNTU_IMG_NAME) deps
	@cp --verbose "$<" "$(UBUNTU_IMG_TMP)"
	@$(SUDO) bash helpers/prepare-raw-image.sh "$(UBUNTU_IMG_TMP)"
	@qemu-img convert -p -f raw -O qcow2 "$(UBUNTU_IMG_TMP)" "$(UBUNTU_IMG_QCOW)"

$(UBUNTU_IMG_NAME): $(UBUNTU_IMG_COMPRESSED) deps
	@unxz --verbose --keep "$<"

$(UBUNTU_IMG_COMPRESSED): deps
	@curl -L -O "$(UBUNTU_RELEASE_URL)"

clean:
	@rm --verbose --force \
		"$(UBUNTU_IMG_COMPRESSED)" \
		"$(UBUNTU_IMG_NAME)" \
		"$(UBUNTU_IMG_TMP)" \
		"$(UBUNTU_IMG_QCOW)" \
		"$(UBUNTU_BOX_NAME)" \
		metadata.json

deps:
	@bash helpers/deps.sh

prep:
	@$(SUDO) bash helpers/install-deps.sh