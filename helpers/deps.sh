#!/usr/bin/env bash

EXIT_CODE=0

while read -r util; do
    util_path=$(which "${util}")
    EXIT_CODE=$(( $? || ${EXIT_CODE}))
    echo "${util} => ${util_path}"
done <<'EOF'
curl
python
losetup
kpartx
partx
mount
umount
qemu-img
tar
gzip
EOF

exit ${CODE}
