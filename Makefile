.PHONY: default

UBUNTU_RELEASE ?= 23.04
UBUNTU_IMG_NAME ?= ubuntu-$(UBUNTU_RELEASE)-preinstalled-server-riscv64+unmatched.img
UBUNTU_IMG_COMPRESSED := $(UBUNTU_IMG_NAME).xz
UBUNTU_RELEASE_URL ?= https://cdimage.ubuntu.com/releases/23.04/release/$(UBUNTU_IMG_COMPRESSED)
UBUNTU_IMG_TMP := ubuntu.img
UBUNTU_IMG_QCOW := box.img
UBUNTU_BOX_NAME := ubuntu-riscv-$(UBUNTU_RELEASE).box

SUDO ?= sudo

default: $(UBUNTU_BOX_NAME)
	@echo "Successfully created vagrant-libvirt box: $(UBUNTU_BOX_NAME)"
	@echo "Completed!"


# TODO: Generate resulting archive
$(UBUNTU_BOX_NAME): $(UBUNTU_IMG_QCOW) metadata.json Vagrantfile
	@false

# TODO: Call a script to generate the JSON file
metadata.json: $(UBUNTU_IMG_QCOW)
	@false

$(UBUNTU_IMG_QCOW): $(UBUNTU_IMG_NAME)
	@cp --verbose "$<" "$(UBUNTU_IMG_TMP)"
	@$(SUDO) bash helpers/prepare-raw-image.sh "$(UBUNTU_IMG_TMP)"
	@qemu-img convert -p -f raw -O qcow2 "$(UBUNTU_IMG_TMP)" "$(UBUNTU_IMG_QCOW)"

$(UBUNTU_IMG_NAME): $(UBUNTU_IMG_COMPRESSED)
	@unxz --verbose --keep "$<"

$(UBUNTU_IMG_COMPRESSED):
	@curl -L -O "$(UBUNTU_RELEASE_URL)"
