 #!/bin/bash
# Ubuntu flavor

sudo export DEBIAN_FRONTEND=noninteractive

sudo apt update
sudo NEEDRESTART_MODE=a apt install python3-pip python3.10-venv -y
sudo apt install python3-pip python3.10-venv -y

# crate venv and activate
python3 -m venv .venv
source .venv/bin/activate


pip install pandas transformers sentencepiece sacremoses torch


 ## python3 already pre-installed
 ## sudo yum install python3
 ## D/L and install pip as user/in home ./local/
 #cd /tmp
 #curl -O https://bootstrap.pypa.io/get-pip.py
 #python3 get-pip.py --user

mkdir AI
cd AI
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/TranslationExample.py >> TranslationExample.py
mkdir DataSets
cd DataSets  
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29%2017%2015%2058_FaceBook_Articles.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles.csv
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29%2017%2015%2058_FaceBook_Articles_short.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles_short.csv
curl https://raw.githubusercontent.com/msteinGH/AWSAISetup/main/AI/Datasets/datacamp_workspace_export_2023-12-29%2017%2015%2058_FaceBook_Articles_very_short.csv >> datacamp_workspace_export_2023-12-29_FaceBook_Articles_very_short.csv
cd ..

python TranslationExample.py

  exit
  
