#!/bin/bash
# Ubuntu flavor
# to be run as user ubuntu/non root

echo "mkdir /extendedDisk/ubuntuExtension" >> ~/user_data._non_root.log
mkdir /extendedDisk/ubuntuExtension


echo "moving .cache" >> ~/user_data._non_root.log
cd ~
mv .cache /extendedDisk/ubuntuExtension/
ln -s /extendedDisk/ubuntuExtension/.cache .

cd /extendedDisk/ubuntuExtension/
echo "python3 -m venv .venv" >> ~/user_data._non_root.log
# create Python venv and activate
python3 -m venv /extendedDisk/ubuntuExtension/.venv
source .venv/bin/activate
cd ~
ln -s /extendedDisk/ubuntuExtension/.venv .

echo "pip install pandas" >> ~/user_data._non_root.log
pip install pandas
echo "pip install sacremoses" >> ~/user_data._non_root.log
pip install sacremoses
echo "pip install transformers sentencepieces" >> ~/user_data._non_root.log
pip install transformers sentencepiece

# required for Sinans BERT classification example
echo "required for Sinans BERT classification example" >> ~/user_data._non_root.log
echo "pip install datasets evaluate scikit-learn transformers[torch]" >> ~/user_data._non_root.log
pip install datasets evaluate scikit-learn transformers[torch]

echo "pip install torch" >> ~/user_data._non_root.log
pip install torch


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
  
