# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Example configuration of new VM..
  #
  #config.vm.define :test_vm do |test_vm|
    # Box name
    #
    #test_vm.vm.box = "centos64"

    # Domain Specific Options
    #
    # See README for more info.
    #
    #test_vm.vm.provider :libvirt do |domain|
    #  domain.memory = 2048
    #  domain.cpus = 2
    #end

    # Interfaces for VM
    #
    # Networking features in the form of `config.vm.network`
    #
    #test_vm.vm.network :private_network, :ip => '10.20.30.40'
    #test_vm.vm.network :public_network, :ip => '10.20.30.41'
  #end

  # Options for Libvirt Vagrant provider.
  config.vm.provider :libvirt do |libvirt|

    # A hypervisor name to access. Different drivers can be specified, but
    # this version of provider creates KVM machines only. Some examples of
    # drivers are KVM (QEMU hardware accelerated), QEMU (QEMU emulated),
    # Xen (Xen hypervisor), lxc (Linux Containers),
    # esx (VMware ESX), vmwarews (VMware Workstation) and more. Refer to
    # documentation for available drivers (http://libvirt.org/drivers.html).
    libvirt.driver = "qemu"

    # Prepare for running emulation instead of virtualization (H-extension)
    libvirt.emulator_path = '/usr/bin/qemu-system-riscv64'
    libvirt.machine_arch = 'riscv64'
    libvirt.machine_type = 'virt'

    # For U-boot built for QEMU (from AUR)
    # IMPORTANT!!! Don't get lost in uboot files, using wrong one will fail the boot!
    libvirt.loader = '/usr/share/u-boot-qemu-bin/qemu-riscv64_smode/uboot.elf'

    # The name of the server, where Libvirtd is running.
    # libvirt.host = "localhost"

    # Inspired by aarch64 SUSE image
    libvirt.host = "localhost"
    libvirt.uri = "qemu:///system"
    libvirt.host = "master"

    # If use ssh tunnel to connect to Libvirt.
    libvirt.connect_via_ssh = false

    # The username and password to access Libvirt. Password is not used when
    # connecting via ssh.
    libvirt.username = "root"
    #libvirt.password = "secret"

    # Configure machine
    libvirt.cpus = 8
    # libvirt.cpu_mode = 'maximum'
    # libvirt.features = []

    # I/O
    libvirt.video_type = "vga"
    libvirt.input :type => "mouse", :bus => "virtio"

    # Libvirt storage pool name, where box image and instance snapshots will
    # be stored.
    libvirt.storage_pool_name = "default"

    # Set a prefix for the machines that's different than the project dir name.
    #libvirt.default_prefix = ''
  end
end
