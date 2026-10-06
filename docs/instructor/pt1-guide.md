# Part 1 teaching guide

!!! tip "Part 1 goals and scope"

    Part 1 builds the conceptual HPC foundations learners need to run Nextflow workflows well on a shared cluster, then applies them to configuring and running a real nf-core pipeline (`nf-core/sarek`). The key goals of Part 1 include:

    - Explaining how HPCs differ from a laptop: shared, scheduled, and resource-constrained
    - Giving learners hands-on experience with modules, containers, and submitting and inspecting scheduler jobs
    - Building intuition for right-sizing resource requests (CPU, memory, walltime) and how this affects queue time and cost
    - Showing how Nextflow executors and configuration files connect a workflow to the HPC scheduler
    - Building an institutional HPC config from scratch, then layering a run-level config on top to tune an nf-core pipeline

    Part 1 is **not**:

    - An introduction to writing Nextflow. Learners are expected to have completed "Hello Nextflow" or equivalent; Nextflow basics are only briefly refreshed in 1.5
    - A variant calling or genomics workshop. WGS short variant calling is the running example, not the subject
    - A deep dive into workflow optimisation. Part 1 introduces the concepts; Part 2 applies them hands-on to a custom pipeline

!!! warning "Two systems, one workshop"

    Every hands-on step is presented in synced tabs for **NCI Gadi HPC (PBS Pro)** and **Pawsey Setonix HPC (Slurm)** because we delivered the original workshop on both systems concurrently. If repeating this on NCI ad Pawsey, say out loud which tab you are on, and remind learners to pick their own system's tab once (the rest of the page follows). Many "it doesn't work" questions in Part 1 come from learners copying commands from the wrong tab.

    If your delivery uses a different system, project codes (`vp91`, `courses01`), queue names, module versions, and the Setonix `--reservation=NextflowHPC` flag all need updating throughout. See [Training materials](materials.md#adapting-the-materials).

## 1.0 Introduction

This lesson gets everyone logged in, with the workspace set up and VSCode opened at the `part1` directory. Nothing conceptual happens here, but every later lesson depends on it, so don't rush it. Budget the full 15 minutes and have facilitators ready to troubleshoot one-on-one.

- Confirm with learners whether the workspace setup (1.0.2) has already been done for them. The lesson tells them you'll let them know on the day
- Ask learners to confirm their username in the terminal prompt before running anything
- Use the Zoom "Yes/No" reactions at the end of the lesson as a hard checkpoint. Don't move on until everyone is set up

??? note "Common setup issues"

    - **Logged in as the wrong user:** learners with existing Gadi or Setonix accounts may have an old entry for the same hostname in `~/.ssh/config`. The lesson shows how to spot and remove it
    - **Gadi default project message:** the Gadi setup script may change the user's default project to `vp91` and ask them to log out and back in. Learners need to close the VSCode window and reconnect, or later `$PROJECT`-based commands will use the wrong project
    - **Wrong folder open in VSCode:** later lessons use relative paths like `../data` and `../singularity`, so VSCode must be opened at `.../nextflow-on-hpc-materials/part1`

## 1.1 HPC for bioinformatics workflows

This is a short lecture and discussion. It introduces what an HPC is, when a workflow actually needs one, and the WGS short variant calling scenario used throughout the workshop.

Your main aim is for learners to leave with three words: **shared, scheduled, resource-constrained**. Every later lesson is a consequence of one of these. You can do this by:

- Framing HPC as a trade-off: massive scale in exchange for less flexibility
- Asking learners which of the "signs your workflow is ready for HPC" they have experienced themselves
- Reassuring learners that they don't need prior knowledge of variant calling. The workflow is a vehicle for the HPC concepts
- Using the "How does HPC help run this workflow?" question for discussion. The point is that each stage has a different bottleneck (I/O, CPU, memory), which sets up resource-aware design in 1.4

??? note "Why design *for* HPC, not just move *to* HPC"

    Learners often expect that a workflow that works on a laptop will simply run faster on an HPC. Emphasise that HPCs expect work to be submitted in a particular way (asynchronously, through a scheduler, with explicit resource requests), so workflows usually need to be designed with that in mind. This is where Nextflow helps: it handles the delayed, out-of-order execution that schedulers introduce.

## 1.2 Software is different on HPC

This lesson explains why software installation is restricted on shared systems, then has learners run `fastqc` first with an environment module and then inside a Singularity container.

The key idea to communicate is that **containers are the recommended approach for Nextflow workflows**. Modules are convenient but depend on what administrators provide; containers give learners control over versions and portability.

- Let learners hit `fastqc: command not found` themselves. It's a deliberate failure that motivates the rest of the lesson
- Point out that Gadi and Setonix provide **different** FastQC versions as modules (0.12.1 vs 0.11.9). This is a concrete example of why modules hurt reproducibility across systems
- Connect `singularity exec <image> <command>` to what Nextflow will do for every task later (1.8)
- Reinforce "one tool, one container, one process", as it comes back in Part 2

??? note "Module quirks to expect"

    - On Setonix, default module versions are **not** loaded automatically; learners must specify the full version (e.g. `fastqc/0.11.9--hdfd78af_1`, `singularity/4.1.0-slurm`). Learners who type `module load fastqc` on Setonix will get an error
    - `module avail` opens a pager. Remind learners to press `q` to exit
    - Learners should run `module unload fastqc` before the container exercise so they're sure the container, not the module, is providing `fastqc`

??? note "What about conda?"

    Learners may ask why conda isn't the recommended option. The comparison table covers it: conda is flexible for development but installs are slow, dependency conflicts are common, environments aren't fully reproducible, and they consume a lot of storage (and inodes) on shared filesystems. Nextflow supports conda, but containers are the best practice on HPC.

## 1.3 HPC architecture

This lesson walks through the components of an HPC (login nodes, compute nodes, queues, shared storage, and the scheduler), then has learners submit `fastqc` as a scheduler job, first with command-line flags and then with header directives.

Your main aim is for learners to understand that **a job's shape (CPU, memory, walltime) determines when and where it runs**. You can do this by:

- Using the scheduler Tetris analogy: well-shaped small jobs slot into gaps, while large awkward jobs wait
- Stressing that over-requesting is not "safe". It causes longer queue times and wasted allocation, not just higher cost
- Stating clearly that the login node is for preparing and submitting work, not running it
- Pointing learners to their system's queue documentation, and making the habit of "read the docs for your HPC" explicit

!!! warning "Typing long multi-line commands"

    The `qsub`/`sbatch` exercise is typed by hand with trailing backslashes. The most common errors are a missing space before `\`, and a trailing `\` on the final line. Walk through it slowly and suggest learners copy the block if they're falling behind.

??? note "System-specific details learners ask about"

    - **Gadi `-l storage=scratch/$PROJECT`:** Gadi does not mount project storage in jobs by default. Forgetting this is a common real-world failure
    - **Gadi `-l wd`:** runs the job in the current working directory. Without it, the job starts in the home directory and relative paths break
    - **Setonix `--reservation=NextflowHPC`:** this is specific to the workshop's reserved node and will not exist outside the event
    - **Internet on compute nodes:** Setonix compute nodes have internet access; most Gadi compute nodes don't (only `copyq`, which is single-CPU, max 10 hours). This matters for pulling containers and reference data in real workflows, so suggest pre-downloading inputs where possible

??? note "Job status codes"

    Learners will poll `qstat -u $USER` or `squeue -u $USER` and may not recognise the states. On Gadi: `Q` queued, `R` running, `E` ending. On Setonix: `PD` pending, `R` running, `CG` completing. Very short jobs may finish before learners see them in the queue at all.

Make sure learners complete 1.3.3: the job ID is saved to `run_id.txt` and is needed at the start of 1.4. Learners who skipped it will need to resubmit the job.

## 1.4 Work smarter, not harder!

This lesson starts with a short exercise inspecting the resource usage of the previous job, then moves into a concept-heavy lecture on right-sizing, CPU and memory efficiency, multi-threading vs. multi-processing (scatter-gather), and how HPC jobs are charged.

The key idea to communicate is that **efficiency is measured, not guessed**. Learners should leave knowing how to check what a job actually used and why that matters for queue time, cost, and fair use.

- Walk through the efficiency output line by line. Compare requested vs. used memory and calculate the efficiency together
- Use the `bwa mem` vs. `fastqc` threads graph: walltime drops with threads for `bwa mem` but not for `fastqc`. Not every tool benefits from more CPUs
- Stress that requesting 8 cores and running 8 threads must match; mismatches either slow the job or waste allocation
- For scatter-gather, always ask "does it make sense biologically to split this?". Per-chromosome variant calling is fine, joint genotyping is not
- Spend time on the "charged on max(CPU proportion, memory proportion)" model. This is the single most useful takeaway for learners paying for their own compute

??? note "Why does Setonix show 2 CPUs allocated?"

    In the `sacct`/`seff` output on Setonix, `AllocCPUS` shows 2 even though 1 CPU was requested, and CPU efficiency is reported against that. Learners may notice this. Setonix nodes have two hardware threads per physical core, so a 1-core request appears as 2 allocated CPUs. It doesn't change the lesson's point.

??? note "Memory and walltime: slightly over-request"

    Learners can take "right-sizing" too far. Reinforce the nuance in the lesson:

    - **Memory:** exceeding the request kills the job, so a small buffer is cheaper than paying twice for a re-run
    - **Walltime:** both Gadi and Setonix charge for walltime **used**, not requested. Over-requesting walltime has no financial cost, only a possible queue-time cost

??? note "Ideal memory per CPU"

    For purely cost-based optimisation, the "free" amount of memory per CPU is about 4 GB on Gadi's `normal` queue (190 GB / 48 CPUs) and about 3.5 GB on Setonix's `work` queue (230 GB / 64 CPUs). The proportions diagram is the clearest way to explain this. Learners will apply it when assigning process resources in Part 2.

## 1.5 Running Nextflow on HPC

This lesson connects the HPC concepts so far to Nextflow. It briefly refreshes processes, channels, and workflows, introduces executors, then has learners run a tiny demo workflow (`config-demo-nf`) on the compute nodes using a provided config and then a profile.

Your main aim is to show that **the executor is what turns Nextflow tasks into scheduler jobs**, and that this is set in configuration, not in the workflow code. You can do this by:

- Keeping the Nextflow refresher short. Learners should already know it; check the room before going into detail
- Pointing to the `executor > pbspro (1)` / `executor > slurm (1)` line in the output as proof the task went to the scheduler
- Explaining that each task runs in its own `work/` subdirectory, and that data moves between tasks only through channels, which matters because tasks may run on different nodes
- Introducing profiles as a convenient way to bundle configuration, which learners will see heavily used in nf-core

!!! warning "Running `nextflow run` on the login node"

    Learners have just been told not to run work on the login node, and now they launch Nextflow there. Address this directly using the callout in the lesson: the head Nextflow job is lightweight and we do it here for simplicity, but real runs should use Gadi persistent sessions or Setonix workflow nodes (with `screen`/`tmux`) so the run survives logout and doesn't load the login node.

??? note "Work directory hashes"

    The example output and the `tree work/` example in the lesson show different hashes (`a8/5345da` vs `6b/e8feb6`). Tell learners their hash will differ from both, and show them how to match the hash in their own terminal output to a directory in `work/`.

This is the natural break point in the Day 1 schedule.

## 1.6 Intro to nf-core

This is a short lecture and guided tour. It introduces the nf-core community, where to find pipelines and their documentation, and the `nf-core/sarek` pipeline used for the rest of Part 1.

- Frame nf-core around "don't reinvent the wheel": check whether a maintained pipeline exists before writing your own
- Do a live tour of [nf-co.re](https://nf-co.re), showing a pipeline page and its Usage, Parameters, and Output tabs. Learners will use the `sarek` docs in 1.7
- Show the sarek subway map, then narrow the focus to the `mapping` stage only. Walk through the eight processes and point out the scatter-gather pattern (`FASTP` splits, `BWAMEM1_MEM` aligns chunks, `MERGE_BAM` gathers), linking back to 1.4
- Note that the workshop clones sarek from GitHub for transparency, but in practice `nextflow run nf-core/<pipeline> -r <version>` pulls it automatically

??? note "Optional content: nf-core pipeline structure and `task.attempt`"

    The collapsible section on pipeline structure and `conf/base.config` is optional. Point interested learners to it, but don't present it unless you're ahead of time. It is worth mentioning the layered resource defaults (`withLabel`, `withName`) because 1.9 builds on them.

    If learners ask about `* task.attempt`: it scales resources on retry, but doubling resources also doubles cost. The lesson shows more nuanced alternatives (adding a small increment, or sizing from input file size).

## 1.7 Running nf-core on HPC

This lesson introduces the samplesheet and other inputs for sarek's `mapping` step, then has learners build a `run.sh` script line by line. The script is deliberately **not run** at the end of the lesson.

- Go through the samplesheet columns and point out that the required columns depend on the sarek step being run (see the sarek usage docs)
- Explain that learners start with `samplesheet.single.csv` (one sample) to keep things fast, and scale up in 1.9
- Explain the "make it run small" parameters: `--step mapping`, `--skip_tools`, `--no_intervals`, and `--igenomes_ignore`. `--no_intervals` is a good discussion point: intervals are great for parallelising large genomes, but for this tiny dataset they would add overhead
- Make it explicit why you're stopping before running: there is no executor configured yet (it would run on the login node), and no container engine (tools aren't installed)

??? note "Common issues building `run.sh`"

    - Forgetting `chmod +x run.sh`, which gives a "permission denied" error later
    - A missing ` \` at the end of a line, or a stray one on the last line
    - Opening the samplesheet: `../data` isn't visible in the VSCode explorer because it sits above the `part1` folder. Learners can use `code ../data/fqs/samplesheet.fq.csv`

## 1.8 Configuring nf-core

This is the main hands-on lesson of Part 1 and the longest (30 minutes). Learners build an institutional HPC config (`config/gadi.config` or `config/setonix.config`) step by step, running the pipeline in between so failures motivate each addition.

!!! warning "Fail on purpose"

    The first run after adding only the executor **is meant to fail** with `fastp: command not found` (exit status 127). Tell learners this before they run it. Then walk through the error message together, showing them where the Work dir is and the "replicate the issue" tip. Reading Nextflow errors is a skill they'll need in Part 2.

Your main aim is for learners to understand what each part of the config does and why it's needed on HPC. Build it in the order the lesson does:

1. `process.executor` and the `executor {}` scope (queue size, submit rate, polling), to submit jobs without overwhelming the scheduler
2. `singularity {}` with `cacheDir`, plus `process.module` to load Singularity on the compute node
3. `clusterOptions` for the project (and, on Setonix, the reservation); `storage` on Gadi
4. A dynamic `queue` chosen from `task.memory`
5. `stageInMode = 'symlink'` and `cache = 'lenient'`
6. The `trace {}` file, used to inspect resource usage

??? note "Points learners often get stuck on"

    - **`System.getenv()`:** used to read `$PROJECT`/`$PAWSEY_PROJECT` and `$USER` so the config isn't hard-coded to one user. Briefly explain that this is Groovy
    - **Gadi `storage` option:** this is **not** a standard Nextflow option; it only exists in the Nextflow build on Gadi. Elsewhere, use `clusterOptions`
    - **Curly braces in `queue = { ... }`:** the braces make it a closure that is evaluated per task, after `task.memory` is known. Without them, it would be evaluated once when the config loads
    - **`cache = 'lenient'`:** shared parallel filesystems can report inconsistent timestamps, causing `-resume` to re-run tasks unnecessarily. Lenient mode ignores timestamps
    - **Order of `-c` configs:** files passed with `-c` take precedence over the pipeline's `nextflow.config`. 1.9 covers this properly

??? note "The working run may be slow to start"

    With the full config, the pipeline runs but uses sarek's default resources (up to 24 CPUs and 30 GB for `BWAMEM1_MEM`). On a busy system, these jobs may queue for a while. This is the teaching point of the trace file: requested vs. `peak_rss` shows massive over-allocation, and 12 `BWAMEM1_MEM` tasks is overkill for this dataset. If the run hasn't finished after a few minutes, have learners cancel with `Ctrl + C` and use the example trace output in the lesson. Consider keeping a completed trace file handy as a fallback.

??? note "nf-core institutional configs"

    End by showing that the config they built is a simplified version of the published [NCI Gadi](https://nf-co.re/configs/nci_gadi/) and [Pawsey Setonix](https://nf-co.re/configs/pawsey_setonix/) configs. Learners sometimes ask why they didn't just use those from the start: building one from scratch is how they learn what each option does, and community configs often still need adjusting (e.g. more complex queue logic, GPU queues).

## 1.9 Layering Nextflow configurations

This lesson explains configuration priority and process selectors, then has learners write a run-level `config/custom.config` that uses `withName` to right-size each sarek process, and finally scale to three samples with `-resume`.

The key idea to communicate is the **three levels of configuration**, each in its own file:

1. **Pipeline-level** (`nextflow.config`, `conf/*.config`): ships with the pipeline, never edited
2. **Institution-level** (`gadi.config`/`setonix.config`): specific to the system, reusable across pipelines
3. **Run-level** (`custom.config`): tunes a pipeline to a specific dataset

- Use the collapsible `params.value` example ("hello" → "bye" → "seeya" → "ciao") to demonstrate priority if learners are unsure. It's quick and memorable
- Emphasise that with `-c a.config,b.config`, later files win
- When comparing the before/after trace files, connect back to 1.4: `FASTQC` and `MULTIQC` now use a large share of their memory, and the tiny jobs aren't worth reducing further because they're already below the "free" memory per CPU
- Point out that giving `FASTP` 2 CPUs means it splits the FASTQ into 2 chunks, so only 2 `BWAMEM1_MEM` tasks run instead of 12. A resource setting changed the scatter width

??? note "Process directive priority"

    From lowest to highest: generic `process {}` settings in config → directives in the process definition → `withLabel` → `withName`. Learners are sometimes surprised that a generic config setting is **overridden** by the process definition, but `withName` in config overrides both.

??? note "Managing expectations about the optimisation"

    Be upfront that learners may not see much difference in queue time or cost for this tiny dataset, especially if the system is quiet. The aim is the practice, which matters at real scale. See the "How much will this improve our run?" callout in the lesson.

??? note "Scaling up with `-resume`"

    In the final exercise, previously completed tasks for the first sample are reused and only the two new samples run, while `MULTIQC` re-runs because its input changed. If learners cancelled their earlier run or changed `custom.config` in between, more tasks may re-run than expected. This is a good chance to explain what goes into a task's hash.

## 1.10 Summary

A short instructor-led recap and Q&A. Revisit the four themes in the lesson (HPCs are shared systems, containers are your friend, Nextflow is portable, fine-tune for your data) and preview Part 2: applying the same ideas to a custom WGS pipeline, including implementing scatter-gather themselves.

Use the remaining time to collect questions, and check in on anyone who fell behind so they're ready for Part 2.

## Known issues in the Part 1 materials

Check these before delivery:

- **1.5:** the example output hash (`a8/5345da`) doesn't match the `work/6b/e8feb6` directory described in the text
- **1.6:** the text refers to "tomorrow's section" and quotes pipeline counts "at the time of writing". Adjust for your schedule
- **1.7:** the "previous section" link points to `./02_1_nfcore_intro.md`, which doesn't exist; it should point to `./01_6_nfcore_intro.md`
- **1.8.1:** the exercise says to create `config/hpc.config`, but the commands create `config/gadi.config` or `config/setonix.config`
- **1.8.4:** the closing paragraphs comparing the workshop config with nf-core configs sit inside the Setonix tab only, so Gadi learners won't see them unless they switch tabs
- **1.9.1:** the default process setting example reads `process.cpu = 1`; the directive is `cpus`
