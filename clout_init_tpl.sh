#!/bin/bash

apt update
apt install -y libguestfs-tools

# set variables
IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMAGE="noble-server-cloudimg-amd64.img"
TEMPLATE_NAME="ubuntu-noble-cloudinit"
VM_ID="9000"
MEMORY="1024"
CPU="1"
DISK_STOR="local-lvm"
NET_BRIDGE="vmbr0"
USER="ubuntu"
SSH_KEY="/root/.ssh/id_rsa.pub"


if [[ $(cat /etc/pve/.vmlist ) == *"\"$VM_ID\""* ]]; then
  echo -e "\033[0;31mVM with ID $VM_ID already exists\033[0m"
  exit 1
fi

if [ ! -f $IMAGE ]; then
  wget $IMAGE_URL -O $IMAGE
fi

virt-customize -a $IMAGE --install qemu-guest-agent

qm create $VM_ID --name $TEMPLATE_NAME --memory $MEMORY --net0 virtio,bridge=$NET_BRIDGE --cpu host --sockets 1 --cores $CPU

qm importdisk $VM_ID $IMAGE $DISK_STOR

qm set $VM_ID --scsihw virtio-scsi-pci --virtio0 $DISK_STOR:vm-$VM_ID-disk-0 --serial0 socket
qm set $VM_ID --boot c --bootdisk virtio0 --ostype l26 --agent 1 --hotplug disk,network,usb
qm set $VM_ID --vcpus 1 --vga qxl --ide2 $DISK_STOR:cloudinit --vmgenid 1 --ipconfig0 ip=dhcp
qm set $VM_ID --ciuser $USER --sshkeys $SSH_KEY

qm template $VM_ID