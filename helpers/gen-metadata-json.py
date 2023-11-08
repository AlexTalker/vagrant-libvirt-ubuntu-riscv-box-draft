#!/usr/bin/env python

import json
import math
import sys
import subprocess

def retrieve_info(image):
    args = [
        'qemu-img',
        'info',
        '--output=json',
        image
    ]
    # Requires Python 3.7
    result = subprocess.run(
        args,
        check=True,
        capture_output=True,
        text=True,
    )

    info = json.loads(result.stdout)

    return info

def calc_virtual_size_gb(info):
    virtual_size = info['virtual-size'] # bytes
    virtual_size_gb = math.ceil(virtual_size / 2**30) # GiB rounded up
    return virtual_size_gb

def calc_metadata(info):
    virtual_size_gb = calc_virtual_size_gb(info)

    metadata = {
        'provider': 'libvirt',
        'format': 'qcow2',
        'virtual_size': virtual_size_gb,
    }

    return metadata

def write_metadata(metadata):
    content = json.dumps(
        metadata,
        indent=4,
        sort_keys=True,
    )

    with open('metadata.json', 'w') as f:
        f.write(content)
        f.write('\n')

if __name__ == '__main__':
    image = sys.argv[1]
    info = retrieve_info(image)
    metadata = calc_metadata(info)
    write_metadata(metadata)