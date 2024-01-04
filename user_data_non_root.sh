#!/bin/bash
# Ubuntu flavor
# to be run as user ubuntu/non root

echo "mkdir /extendedDisk/ubuntuExtension" >> ~/user_data_non_root.log
mkdir /extendedDisk/ubuntuExtension

if [ ! -d .cache ]; then
    echo "Creating new dir .cache" >> ~/user_data_non_root.log
    mkdir .cache
fi

cd ~
echo "moving .cache" >> ~/user_data_non_root.log
cd ~
mv .cache /extendedDisk/ubuntuExtension/
ln -s /extendedDisk/ubuntuExtension/.cache .

cd /extendedDisk/ubuntuExtension/
echo "python3 -m venv .venv" >> ~/user_data_non_root.log
# create Python venv and activate
python3 -m venv /extendedDisk/ubuntuExtension/.venv
source .venv/bin/activate
cd ~
ln -s /extendedDisk/ubuntuExtension/.venv .



echo "D/L AI contents from https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/" >> ~/user_data_non_root.log
mkdir AI
cd AI
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/TranslationExample.py >> TranslationExample.py
mkdir DataSets
cd DataSets  
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29_FaceBook_Articles.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles.csv
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29_FaceBook_Articles_short.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles_short.csv
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29_FaceBook_Articles_very_short.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles_very_short.csv

curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/BERT_for_Sequence_Classification_by_Sinan.py >> BERT_for_Sequence_Classification_by_Sinan.py



cd ~ubuntu

echo "D/L and executing install_via_pip.sh" >> ~/user_data_non_root.log
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/install_via_pip.sh >> install_via_pip.sh
chmod 755 install_via_pip.sh
./install_via_pip
exit
  
