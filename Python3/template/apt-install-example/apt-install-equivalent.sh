#!/bin/bash

apt purge -y lxd lxd-client
apt install -y qemu qemu-kvm qemu-utils libvirt-bin libvirt0
apt install -y openvswitch-switch
apt install -y dkms dpdk dpdk-dev openvswitch-switch-dpdk
