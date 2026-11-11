# Training infrastructure

This page lists what you need in place before delivering the *Nextflow for HPC* workshop. Step-by-step instructions for preparing a training environment are in the [setup guide](https://github.com/GiorgiaMori/nf4hpc-materials/blob/main/setup/README.md).

The workshop runs on a Linux high-performance computing (HPC) system with a job scheduler. We have delivered it on:

- [NCI Gadi](https://nci.org.au/our-systems/hpc-systems), which uses the PBS Pro scheduler
- [Pawsey Setonix](https://pawsey.org.au/systems/setonix/), which uses the Slurm scheduler

The materials can be adapted to other HPC systems. See [Adapting the materials](materials.md#adapting-the-materials).

## What participants need

Participants need a personal computer with:

- A web browser
- An SSH client (built in on macOS and Linux; Windows users may need [OpenSSH](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse))
- [VSCode](https://code.visualstudio.com/) with the Remote - SSH extension (see the [participant setup instructions](../workshop/setup.md))
- Any VPN or multi-factor authentication tools required by the HPC provider

Each participant also needs their own training account on the HPC, with access to the training project and permission to submit jobs.

Before the workshop, participants should confirm they can log in.

## What the HPC system needs

| Requirement | Gadi (PBS Pro) | Setonix (Slurm) |
| ----------- | -------------- | --------------- |
| Training project | `vp91` | `courses01` |
| Workshop folder | `/scratch/vp91/<user>/nextflow-on-hpc-materials` | `/scratch/courses01/<user>/nextflow-on-hpc-materials` |
| Queue or partition | `normalbw` | `work` |
| Nextflow | `module load nextflow/24.04.5` | `module load nextflow/24.10.0` |
| Singularity (runs software containers) | `module load singularity` | `module load singularity/4.1.0-slurm` |
| Reservation | None | `NextflowHPC` |
| Container images | Pre-pulled into `<workshop folder>/singularity` | Pre-pulled into `<workshop folder>/singularity` |

Java is provided by the Nextflow module, so it does not need to be installed separately.

Workshop tasks are small. Most request 1–2 CPUs and about 2–9 GB of memory, and the workshop configuration limits each participant to 30 jobs at once (`queueSize = 30`).

If you deliver on another system, replace the values above with the equivalents for your site.

## Workshop files and data

All code and data are in [nextflow-on-hpc-materials](https://github.com/Sydney-Informatics-Hub/nextflow-on-hpc-materials):

- `data/`: sequencing data for three samples, and a reference genome (chromosomes 20–22)
- `part1/`: configuration and script examples for Part 1
- `part2/`: the custom pipeline used in Part 2
- `setup.gadi.sh` and `setup.setonix.sh`: scripts that prepare each participant's workspace

Each participant copies this into their own scratch folder and runs the setup script for their system, as described in [lesson 1.0.2](../workshop/part1/01_0_intro.md#102-setup-the-workspace). You can run this for each account before the workshop. If you do, tell participants on the day, because they can then skip that step.

Part 1 uses [nf-core/sarek](https://nf-co.re/sarek) version 3.5.0, which the setup script downloads.

## Containers

Containers package software so that it runs the same way everywhere. The workshop uses Singularity containers and pre-pulls them so participants do not wait for downloads. The setup guide explains how to build and share this set of container images.

## Settings to confirm locally

The materials do not state the following. Fill this in for your delivery:

| Setting | Your value |
| ------- | ---------- |
| Storage available per participant | |
| Maximum jobs per participant | |
| Training account expiry date | |
| Support contact | |

## Pre-workshop checklist

- [ ] All participants can log in to the training system
- [ ] `nextflow -version` works after loading the module
- [ ] Participants can submit and monitor a small job
- [ ] Containers run on compute nodes
- [ ] Workshop files and data are readable and writable for each participant
- [ ] A small test workflow completes
- [ ] The queue or partition can handle all participants running jobs at once
- [ ] Storage limits and job limits are sufficient
- [ ] A shared space for questions (for example Slack or a Google Doc) is set up and linked
- [ ] Example outputs and logs are available in case live jobs are delayed

## After the workshop

Tell participants which files to keep, such as their configuration files and reports, and when their training account or storage will expire.
