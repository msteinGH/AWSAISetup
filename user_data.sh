#!/bin/bash
# Ubuntu flavor
# NOT required for superuser!!
# not executed for some strange reason???

echo "whoami" >> ~ubuntu/user_data.log
whoami >> ~ubuntu/user_data.log
echo "apt update" >> ~ubuntu/user_data.log
apt update
echo "NEEDRESTART_MODE=a apt install jq python3-pip python3.10-venv -y" >> ~ubuntu/user_data.log
NEEDRESTART_MODE=a apt install jq python3-pip python3.10-venv -y

# mount new volume, create target mountpoint
echo "mkdir /extendedDisk" >> ~ubuntu/user_data.log
mkdir /extendedDisk

# Helper commands
# list available disks 
# lsblk 
# check if filesystem available eg.
# file -s /dev/nvme1n1

# needs jq to identify unmounted disk name dynamically
# creating small script dynamically to be executed via sudo
echo "Creating mountdiskcommand" >> ~ubuntu/user_data.log
echo "mkfs -t xfs /dev/$(lsblk --fs --json | jq -r '.blockdevices[] | select(.children == null and .mountpoints == [null]) | .name')" >> mountdiskcommand
echo "mount /dev/$(lsblk --fs --json | jq -r '.blockdevices[] | select(.children == null and .mountpoints == [null]) | .name') /extendedDisk" >> mountdiskcommand

echo "chmod 755 mountdiskcommand" >> ~ubuntu/user_data.log
chmod 755 mountdiskcommand

./mountdiskcommand

echo "chown ubuntu /extendedDisk" >> ~ubuntu/user_data.log
chown ubuntu /extendedDisk

echo "D/L user_data_non_root.sh" >> ~ubuntu/user_data.log
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/user_data_non_root.sh >> user_data_non_root.sh

chmod 755 user_data_non_root.sh
echo "sudo -u user_data_non_root.sh" >> ~ubuntu/user_data.log

sudo -u user_data_non_root.sh



  exit
  
