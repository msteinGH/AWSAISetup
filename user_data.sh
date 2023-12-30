 #!/bin/bash
# Ubuntu flavor

sudo export DEBIAN_FRONTEND=noninteractive

sudo apt update
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

  curl https://raw.githubusercontent.com/msteinGH/TerraFormSamplesAWS/main/SampleData/StaticHtml/index.jsp >> index.jsp 
  chgrp tomcat index.jsp 

  exit
  
