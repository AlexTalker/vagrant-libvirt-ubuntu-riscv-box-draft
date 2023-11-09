#!/usr/bin/env bash

set -e

echo "System: $(uname -a)"

cat /etc/os-release || true

if which apt >/dev/null; then
    DEBIAN_FRONTEND=noninteractive exec apt install \
        curl \
        python3 \
        util-linux \
        kpartx \
        qemu-utils
fi

echo "Unsupported system!"

exit 1
