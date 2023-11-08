#!/usr/bin/env bash

set -e

shopt -s nullglob

function cleanup() {
    # Avoid recursion
    trap - EXIT

    [ -n "${CIDATA_PARTITION}" ] && umount "${CIDATA_PARTITION}"
    [ -n "${LOOP_DEV}" ] && {
        kpartx -d "${LOOP_DEV}" || true
        losetup -d "${LOOP_DEV}"
    }
}

trap cleanup EXIT

RAW_IMAGE="${1}"
LOOP_DEV=$(losetup --find --nooverlap --partscan --show "${RAW_IMAGE}")

[ -z "${LOOP_DEV}" ] && exit 1

echo "loopback device: ${LOOP_DEV}"

LOOP_NAME=$(basename "${LOOP_DEV}")

# Unfortunately, /dev/disk might not be available, so search desired partition number manually
CIDATA_NR=$(partx --show "${LOOP_DEV}" | awk -e '$6 == "CIDATA" { print $1; }')
CIDATA_PARTITION="/dev/mapper/${LOOP_NAME}p${CIDATA_NR}"

echo "CIDATA partition NR: ${CIDATA_NR}"
echo "CIDATA partition: ${CIDATA_PARTITION}"

# add,verbose,sync
kpartx -avs "${LOOP_DEV}"

ls -lah "${CIDATA_PARTITION}"

file -s -L "${CIDATA_PARTITION}"

CIDATA_DIR="$(mktemp --directory)"

echo "Mounting ${CIDATA_PARTITION} into ${CIDATA_DIR}"

mount "${CIDATA_PARTITION}" "${CIDATA_DIR}"

# TODO: Copy our cloudinit information into the partition
ls -lah "${CIDATA_DIR}"

cp --verbose cidata/* "${CIDATA_DIR}"