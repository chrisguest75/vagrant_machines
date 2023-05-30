#!/bin/bash
MACHINENAME=$1

# Download ubuntu.iso
if [ ! -f ./ubuntu.iso ]; then
    wget https://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso -O ubuntu.iso
fi

# Create VM
VBoxManage createvm --name $MACHINENAME --ostype "Debian_64" --register --basefolder $(pwd)

# Set memory and network
VBoxManage modifyvm $MACHINENAME --ioapic on
VBoxManage modifyvm $MACHINENAME --memory 1024 --vram 128
VBoxManage modifyvm $MACHINENAME --nic1 nat

# Create Disk and connect Debian Iso
VBoxManage createhd --filename $(pwd)/$MACHINENAME/${MACHINENAME}_DISK.vdi --size 80000 --format VDI
VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  $(pwd)/$MACHINENAME/${MACHINENAME}_DISK.vdi
VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $(pwd)/ubuntu.iso
VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Enable RDP
VBoxManage modifyvm $MACHINENAME --vrde on
VBoxManage modifyvm $MACHINENAME --vrdemulticon on --vrdeport 10001

# Start the VM
VBoxHeadless --startvm $MACHINENAME
