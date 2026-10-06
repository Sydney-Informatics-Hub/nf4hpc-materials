# nf4hpc-materials

A GitHub template repository for delivering the **Nextflow for HPC** workshop. When you create a new repository from this template, a GitHub Actions workflow automatically populates it with the full workshop content, with instructor notes removed and your organisation's details substituted in.

## Using this template

1. Click [**Use this template** on the GitHub repository](https://github.com/Sydney-Informatics-Hub/nf4hpc-materials) and create a new repository under your org/username
2. The `template.yml` workflow fires automatically on the first push, running cookiecutter to:
   - Populate the repo with the workshop materials from this template
   - Replace repo name, site name, and GitHub username throughout
   - Strip instructor-only notes
   - Set up the MkDocs deploy workflow
3. After a few seconds, your repo will contain the full workshop site, ready to deploy to GitHub Pages.

## What the generated repo contains

- Full workshop content (Part 1 and Part 2) from the Nextflow for HPC workshop:
  - **Part 1:** conceptual HPC foundations (schedulers, modules and containers, resource requests and job costs) and configuring and running `nf-core/sarek` on HPC
  - **Part 2:** configuring, profiling, optimising, and scaling a custom multi-sample variant calling pipeline on HPC
- Worked examples for [NCI Gadi](https://nci.org.au/our-systems/hpc-systems) (PBS Pro) and [Pawsey Setonix](https://pawsey.org.au/systems/setonix/) (Slurm), which can be adapted to other HPC systems
- MkDocs site with Material theme, auto-deployed to GitHub Pages on push to `main`
- Setup scripts and sample data for the training environment. Workshop code and data are provided in [nextflow-on-hpc-materials](https://github.com/Sydney-Informatics-Hub/nextflow-on-hpc-materials)

## Enabling GitHub Pages in the generated repo

1. Go to **Settings → Pages** in your new repo.
2. Set **Source** to **Deploy from a branch**, branch `gh-pages`, folder `/ (root)`.
3. Go to **Actions** and enable workflows if prompted.

Your site will be published at `https://<github_account>.github.io/<repo_name>/`.

## Acknowledgements

Materials developed by the [Sydney Informatics Hub](https://www.sydney.edu.au/research/facilities/sydney-informatics-hub.html), enabled by Australian BioCommons' BioCLI Platforms Project.

These materials have been developed by:

- Georgie Samaha, Sydney Informatics Hub, University of Sydney
- Michael Geaghan, Sydney Informatics Hub, University of Sydney
- Mitchell O'Brien, Sydney Informatics Hub, University of Sydney
- Fred Jaya, Sydney Informatics Hub, University of Sydney
- Giorgia Mori, Australian BioCommons
