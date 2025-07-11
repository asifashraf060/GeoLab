#!/bin/bash
# This downloads and installs a pinned version of mambaforge
set -ex

cd $(dirname $0)
MAMBAFORGE_VERSION=23.1.0-1

#https://github.com/conda-forge/miniforge/releases/download/23.1.0-1/Mambaforge-23.1.0-1-MacOSX-arm64.sh
URL="https://github.com/conda-forge/miniforge/releases/download/${MAMBAFORGE_VERSION}/Mambaforge-${MAMBAFORGE_VERSION}-MacOSX-arm64.sh"
INSTALLER_PATH=/tmp/mambaforge-installer.sh

#wget --quiet $URL -O ${INSTALLER_PATH}
chmod +x ${INSTALLER_PATH}

bash ${INSTALLER_PATH} -b -p ${CONDA_DIR}
export PATH="${CONDA_DIR}/bin:$PATH"

# Do not attempt to auto update conda or dependencies
conda config --system --set auto_update_conda false
conda config --system --set show_channel_urls true

# empty conda history file,
# which seems to result in some effective pinning of packages in the initial env,
# which we don't intend.
# this file must not be *removed*, however
echo '' > ${CONDA_DIR}/conda-meta/history

# Clean things out!
conda clean --all -f -y

# Remove the big installer so we don't increase docker image size too much
rm ${INSTALLER_PATH}

# Remove the pip cache created as part of installing mambaforge
rm -rf /root/.cache

chown -R $NB_USER:$NB_USER ${CONDA_DIR}

conda list -n root
