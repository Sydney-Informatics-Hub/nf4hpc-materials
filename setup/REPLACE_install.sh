#!/bin/bash -eu

source lib/prep_files.sh
source lib/utils.sh
source lib/validate_workshop.sh

JAVA_VERSION="21"
NXF_VERSION="24.10.0"
SINGULARITY_VERSION="4.1.1+ds2-1ubuntu0.3" # apt version

## apt
log "Updating and upgrading packages..."
sudo apt update -y && sudo apt upgrade -y

log "Installing required system utilities..."
SYSUTILS=(zip unzip tree curl)
sudo apt install -y "${SYSUTILS[@]}"

log "Checking system utilities are executable..."
for util in "${SYSUTILS[@]}"; do
    check_executable "$util"
done
check_executable tr

log "Installing open-jdk-${JAVA_VERSION}-jre..."
sudo apt install -y "openjdk-${JAVA_VERSION}-jre"

log "Verifying java install..."
check_executable "java -version"

## Nextflow
log "Installing Nextflow v${NXF_VERSION}"
curl -sL "https://github.com/nextflow-io/nextflow/releases/download/v${NXF_VERSION}/nextflow" \
	-o nextflow
chmod 755 ./nextflow

# Move to $PATH
sudo mv ./nextflow /usr/local/bin

log "Verifying nextflow install..."
check_executable "nextflow --version"

## Singularity
log "Installing singularity..."
sudo apt install -y singularity-container=${SINGULARITY_VERSION}
# fix version, do not upgrad
sudo apt-mark hold singularity-container

log "Verifying singularity: $(singularity --version | grep ${SINGULARITY_VERSION})"

log "Pulling biocontainers"
# When pulling containers outside of Nextflow, the default name doesn't match
# what Nextflow expects
# [0]: Link to pull container
# [1]: Amended name for nextflow to recognise
IMAGES=(
	"quay.io/biocontainers/salmon:1.10.1--h7e5ed60_0 quay.io-biocontainers-salmon-1.10.1--h7e5ed60_0.img"
	"quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0 quay.io-biocontainers-fastqc-0.12.1--hdfd78af_0.img"
	"quay.io/biocontainers/multiqc:1.19--pyhdfd78af_0 quay.io-biocontainers-multiqc-1.19--pyhdfd78af_0.img"
)

# Export cachedir in .bashrc 
if grep -q "SINGULARITY_CACHEDIR" ~/.bashrc; then
	log "SINGULARITY_CACHEDIR already exported"
else
	log "Adding SINGULARITY_CACHEDIR to .bashrc"
	echo "export SINGULARITY_CACHEDIR=${HOME}/singularity" >> ~/.bashrc
fi
	
# source for installation
SINGULARITY_CACHEDIR=${HOME}/singularity
mkdir -p ${SINGULARITY_CACHEDIR}

# In the original workshop, we used docker and docker images.
# We have since replaced docker with singularity
# For reproducibility, pull the docker images with singularity
# by adding "docker://" 
for image in "${IMAGES[@]}"; do
	# unpack string by " "
	read -r url img <<< $image
	if [[ ! -f "${SINGULARITY_CACHEDIR}/${img}" ]]; then
		singularity pull "${SINGULARITY_CACHEDIR}/${img}" "docker://${url}"
	else
		log "Skipping ${img} (already exists)"
	fi
done

# Copy workshop folders and files into the home dir by default
prep_files "$HOME"
run_part2 "$HOME"

log "Installation for $USER successful!"
