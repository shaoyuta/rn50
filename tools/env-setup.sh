#!/bin/bash

CONDA_VER="py39_4.10.3"
CONDA_REPO="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VER}-Linux-x86_64.sh"

cd /opt 
wget --quiet --no-check-certificate ${CONDA_REPO} -O miniconda.sh 
/bin/bash ./miniconda.sh -b -p /opt/anaconda3 
rm miniconda.sh 
/opt/anaconda3/bin/conda clean -tipsy 
ln -s /opt/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh 
echo ". /opt/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc 
echo "conda activate base" >> ~/.bashrc 
conda config --set always_yes yes --set changeps1 no

conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0

ZENDNN_VER="3.3"
PYTHON_VER="3.9"
TF_VER="2.9" 
ZENDNN_REPO="https://af01p-igk.devtools.intel.com/artifactory/platform_hero-igk-local/ZenDNN_TensorFlow/TF_v${TF_VER}_ZenDNN_v${ZENDNN_VER}_Python_v${PYTHON_VER}.zip"
wget --no-check-certificate ${ZENDNN_REPO} 
unzip TF_v${TF_VER}_ZenDNN_v${ZENDNN_VER}_Python_v${PYTHON_VER}.zip -d TF_ZEN 
rm TF_v${TF_VER}_ZenDNN_v${ZENDNN_VER}_Python_v${PYTHON_VER}.zip

conda init bash
mv /home/workspace/TF_ZEN/TF_*/* /home/workspace && rm -r TF_ZEN/ && rm -rf /home/workspace/benchmarks/
cp scripts/gather_hw_os_kernel_bios_info.sh .
chmod 777 -R ./scripts/* && git config --global http.sslverify false
export ENV WHL_FILE=$(pwd)/tensorflow-2.7.0-cp39-cp39-manylinux2014_x86_64.whl && /bin/bash scripts/TF_ZenDNN_setup_release.sh