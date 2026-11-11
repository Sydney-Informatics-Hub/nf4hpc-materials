# Nextflow for HPC: environment setup

This guide helps trainers prepare an HPC system for the workshop. Participants then follow the setup lesson in the workshop materials ([lesson 1.0.2](../docs/workshop/part1/01_0_intro.md#102-setup-the-workspace)).

The [training infrastructure page](../docs/instructor/environment.md) lists what the system needs. This page explains how to set it up.

## Before you start

You need:

- A training project on the HPC with scratch storage
- A training account for each participant, with access to that project
- Permission to submit jobs to the training queue or partition
- Internet access from a login or data-transfer node, to download container images

The examples below use the projects from previous deliveries (`vp91` on Gadi, `courses01` on Setonix). Replace them with your own.

## Step 1: Prepare the shared container images

Container images package the software the workshop uses. Download them once into a shared tar file, so participants do not each download them.

The build scripts are in the [`.assets/` folder of nextflow-on-hpc-materials](https://github.com/Sydney-Informatics-Hub/nextflow-on-hpc-materials/tree/main/.assets):

- `pull_singularity.pbs.sh` for Gadi
- `pull_singularity.slurm.sh` for Setonix

Before you submit them, edit the project, storage and output path settings. The scripts contain the project codes used in earlier deliveries (`ad78` on Gadi and `pawsey1227` on Setonix).

Each script downloads the workshop's container images and creates a `singularity.tar` file.

Copy the tar file to a location all training accounts can read:

| System | Location the setup scripts expect |
| ------ | --------------------------------- |
| Gadi | `/scratch/vp91/singularity.tar` |
| Setonix | `/scratch/courses01/singularity.tar` |

On Gadi, `cp_singularity.pbs.sh` can copy the file for you. If you use a different location, edit the path in `setup.gadi.sh` or `setup.setonix.sh`.

## Step 2: Prepare each participant's workspace

Each participant needs their own copy of the workshop files. For each account, run:

```bash
cd /scratch/<PROJECT>/<USER>
git clone https://github.com/Sydney-Informatics-Hub/nextflow-on-hpc-materials.git
cd nextflow-on-hpc-materials
./setup.gadi.sh      # on Gadi
./setup.setonix.sh   # on Setonix
```

The script:

1. Unpacks the reference genome
2. Downloads `nf-core/sarek` (version 3.5.0) and the `config-demo-nf` example
3. Unpacks the container images into the participant's `singularity` folder

When it finishes it prints "Setup complete".

On Gadi, `.assets/setup_gadi_accounts.sh` shows how to do this for many accounts over SSH.

If you do this ahead of time, tell participants they can skip lesson 1.0.2.

!!! warning "Gadi default project"

    On Gadi, the script may change the participant's default project to `vp91` in `~/.config/gadi-login.conf`. If it does, the participant must log out and back in before continuing.

## Step 3: Check the setup

Log in as a test participant and check:

- [ ] `module load nextflow/<version>` and `nextflow -version` work
- [ ] `module load singularity` works (use `singularity/4.1.0-slurm` on Setonix)
- [ ] The `singularity` folder inside `nextflow-on-hpc-materials` contains the container images
- [ ] The `data/ref` folder contains the unpacked reference files
- [ ] A small test job can be submitted and finishes
- [ ] The `config-demo-nf` example from lesson 1.5 completes

## Software versions used

| Software | Gadi | Setonix |
| -------- | ---- | ------- |
| Nextflow | 24.04.5 | 24.10.0 |
| Singularity | Default `singularity` module | 4.1.0-slurm |
| nf-core/sarek | 3.5.0 | 3.5.0 |

Check these still match what is installed at your site before delivering.

## Using a different HPC

You will need to:

- Provide the Nextflow and Singularity modules, or install them
- Create a configuration file for your scheduler, modelled on `part2/config/pbspro.config` or `part2/config/slurm.config`
- Update queue names, project codes, scratch paths and memory per CPU in the lessons
- Build a container image set and update the setup script paths
