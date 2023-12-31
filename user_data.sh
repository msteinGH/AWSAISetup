 #!/bin/bash
# Ubuntu flavor

echo "sudo apt update" >> ~/user_data.log
sudo apt update
echo "sudo NEEDRESTART_MODE=a apt install jq python3-pip python3.10-venv -y" >> ~/user_data.log
sudo NEEDRESTART_MODE=a apt install jq python3-pip python3.10-venv -y

# mount new volume, create target mountpoint
echo "sudo mkdir /extendedDisk" >> ~/user_data.log
sudo mkdir /extendedDisk

# Helper commands
# list available disks 
# lsblk 
# check if filesystem available eg.
# sudo file -s /dev/nvme1n1

# needs jq to identify unmounted disk name dynamically
# creating small script dynamically to be executed via sudo
echo "Creating mountdiskcommand" >> ~/user_data.log
echo "mkfs -t xfs /dev/$(lsblk --fs --json | jq -r '.blockdevices[] | select(.children == null and .mountpoints == [null]) | .name')" >> mountdiskcommand
echo "mount /dev/$(lsblk --fs --json | jq -r '.blockdevices[] | select(.children == null and .mountpoints == [null]) | .name') /extendedDisk" >> mountdiskcommand

echo "chmod 755 mountdiskcommand" >> ~/user_data.log
chmod 755 mountdiskcommand
#sudo mkfs -t xfs /dev/nvme1n1
#sudo mount /dev/nvme1n1 /extendedDisk
sudo ./mountdiskcommand

echo "sudo chown ubuntu /extendedDisk" >> ~/user_data.log
sudo chown ubuntu /extendedDisk

echo "mkdir /extendedDisk/ubuntuExtension" >> ~/user_data.log
mkdir /extendedDisk/ubuntuExtension

cd ~
mv .cache /extendedDisk/ubuntuExtension/
ln -s /extendedDisk/ubuntuExtension/.cache .
cd /extendedDisk/ubuntuExtension/

echo "python3 -m venv .venv" >> ~/user_data.log
# create Python venv and activate
python3 -m venv .venv
source .venv/bin/activate
cd ~
ln -s /extendedDisk/ubuntuExtension/.venv .

echo "pip install pandas" >> ~/user_data.log
pip install pandas
echo "pip install sacremoses" >> ~/user_data.log
pip install sacremoses
echo "pip install transformers sentencepieces" >> ~/user_data.log
pip install transformers sentencepiece
# pip install torch


mkdir AI
cd AI
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/TranslationExample.py >> TranslationExample.py
mkdir DataSets
cd DataSets  
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29_FaceBook_Articles.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles.csv
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29_FaceBook_Articles_short.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles_short.csv
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29_FaceBook_Articles_very_short.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles_very_short.csv
cd ..

# python TranslationExample.py

  exit
  
