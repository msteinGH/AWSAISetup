#!/bin/bash
# Ubuntu flavor
# to be run as user ubuntu/non root

cd ~ubuntu
source .venv/bin/activate

echo "pip install pandas PyPDF2" >> ~/user_data_non_root.log
pip install pandas PyPDF2
echo "pip install sacremoses" >> ~/user_data_non_root.log
pip install sacremoses
echo "pip install transformers sentencepiece" >> ~/user_data_non_root.log
pip install transformers sentencepiece

# required for Sinans BERT classification example
echo "required for Sinans BERT classification example" >> ~/user_data_non_root.log
echo "pip install datasets evaluate scikit-learn transformers[torch]" >> ~/user_data_non_root.log
pip install datasets evaluate scikit-learn transformers[torch]

echo "pip install torch" >> ~/user_data_non_root.log
pip install torch

python ~/GITRepos/AWSAISetup/AI/DownloadAIComponents.py