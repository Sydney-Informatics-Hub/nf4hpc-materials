# Training environment

This page provides information about the technical setup required to run the *Nextflow for HPC* workshop.

The workshop requires access to a Linux HPC environment with a supported job scheduler. Materials can be adapted for:

- Institutional HPC systems
- National HPC systems
- Cloud-based training clusters with a job scheduler
- Other preconfigured HPC training environments

## Hardware and resource requirements

Participants require a personal computer with a reliable internet connection. Workflow execution takes place on the training HPC system.

Trainers should arrange sufficient compute capacity and storage for all participants to complete the exercises.

| Requirement | Workshop specification |
| ----------- | ---------------------- |
| Operating system | Linux |
| Scheduler | Slurm / PBS Pro / other supported scheduler |
| CPUs per task | Insert requirements for workshop tasks |
| Memory per task | Insert requirements for workshop tasks |
| Task walltime | [Insert expected runtime and requested limits] |
| Storage per participant | [Insert space required for data, containers, work directories, and outputs] |
| Compute allocation | [Insert project/account and allocation requirements] |
| Queue or partition | [Insert training queue or partition] |
| Concurrent jobs | [Insert per-user limits and capacity needed for the learner group] |

## Software requirements

### Participants

Participants require a personal computer with:

- A web browser
- An SSH client
- A code editor, such as VSCode with the Remote - SSH extension, if supported by the training system
- Access to the selected HPC environment
- Any VPN or multi-factor authentication tools required by the HPC provider

Before the workshop, participants should install the required software and confirm that they can connect to the training system.

### Training environment

The following software must be installed and available to all participants:

- Nextflow
- A Java version compatible with the selected Nextflow version
- Singularity or Apptainer for container execution
- The selected scheduler’s job submission and monitoring commands
- Any additional tools required by the workshop exercises

Record the versions tested with the workshop materials:

| Software | Tested version | How participants access it |
| -------- | -------------- | -------------------------- |
| Nextflow | [Insert version] | Module |
| Java | [Insert version] | Module |
| Singularity | [Insert version] | Module |

## HPC access and configuration

Participants must have:

- An active account on the training system
- Access to the required project or compute allocation
- Permission to submit jobs to the selected queue or partition
- Access to suitable working and output directories

Provide the local settings needed for the workshop:

| Setting | Value or instructions |
| ------- | --------------------- |
| Login hostname | [Insert hostname] |
| Account setup | [Insert registration or access instructions] |
| Project/account code | [Insert code or explain how participants obtain it] |
| Nextflow executor | [Insert executor appropriate to the scheduler] |
| Queue or partition | [Insert name] |
| Main Nextflow job | [Explain where and how to run it under local HPC policy] |
| Working directory | [Insert path or instructions] |
| Output directory | [Insert path or instructions] |
| Container cache | [Insert path and configuration instructions] |

### Main Nextflow job and workflow tasks

Explain where participants should run the main Nextflow job and how it submits individual workflow tasks to the scheduler.

[Insert the workshop’s submission script or link to the relevant instructions. Include any required account, queue, CPU, memory, and walltime settings.]

### Filesystem access

The main Nextflow job and scheduled tasks must be able to access the required workflow files, inputs, containers, and work directory.

[Describe shared filesystem paths, permissions, storage quotas, and any site-specific restrictions.]

## Workshop files and data

Stage the workshop files and data before the session.

| Resource | Location or setup instructions |
| -------- | ------------------------------ |
| Workshop code | [Insert repository URL and release] |
| Input data | [Nextflow on HPC materials](https://github.com/Sydney-Informatics-Hub/nextflow-on-hpc-materials) |
| Nextflow configuration | [Insert configuration path or profile name] |
| Container images | [Insert image locations] |
| Example outputs and logs | [Insert location of fallback materials] |

[Explain whether participants copy files into their own directories or access shared, read-only inputs.]

## Containers

Make all required container images available before the workshop to avoid download delays.

Trainers should confirm that:

- Images are compatible with the training system
- Participants can read the images from compute nodes
- Required input, work, and output directories are accessible inside containers
- Container cache directories have sufficient space and suitable permissions
- Any restrictions on network access or container execution are addressed

[Insert image preparation instructions and any required bind paths or Nextflow container settings.]

## Preconfigured setup

[Link to the setup instructions for the selected HPC system.]

These instructions should cover:

- Account access and login
- Loading the required software
- Obtaining workshop files and data
- Preparing container images
- Configuring the scheduler and resource requests
- Running a small test workflow

## Recommended pre-workshop checks

Before the workshop begins, trainers should verify:

- All participants can connect to the training system
- Nextflow returns the expected version using `nextflow -version`
- Java and the container runtime return the expected versions
- Participants can submit and monitor a small scheduler job
- Containers can execute successfully on compute nodes
- Workshop files and data are readable from the required locations
- Participants can write to their work and output directories
- A small Nextflow workflow completes using the workshop configuration
- The training queue and compute allocation can support concurrent participant jobs
- Storage quotas and job limits are sufficient
- Shared learner support space is set up and linked
- Completed outputs and logs are available if live jobs are delayed

## Cleanup after the workshop

[Explain which files participants should retain, which temporary files can be removed, and when training accounts or storage will expire.]

- **Files to retain:** [Scripts, configuration, reports, or other outputs]
- **Files to remove:** [Temporary work directories or copied training data]
- **Access expiry:** [Insert date or policy]
- **Support contact:** [Insert contact details]