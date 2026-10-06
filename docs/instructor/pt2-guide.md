# Part 2 teaching guide

!!! tip "Part 2 goals and scope"

    Part 2 replicates a "real-life" scenario: taking a custom Nextflow pipeline that was developed on a laptop and getting it running, then running efficiently, on HPC. Learners work with a provided WGS short variant calling pipeline and progressively configure, profile, optimise, and scale it. The key goals of Part 2 include:

    - Applying the HPC and configuration concepts from Part 1 to a custom pipeline, without the scaffolding nf-core provides
    - Building the habit of diagnosing failures from Nextflow error messages, logs, and work directories
    - Using Nextflow's reporting features (reports, timelines, trace files, `nextflow log`) to make evidence-based resource decisions
    - Implementing multi-threading and scatter-gather parallelism, and judging when each is appropriate
    - Showing that a well-configured pipeline scales to more samples without code changes

    Part 2 is **not**:

    - A guide to variant calling or to writing Nextflow from scratch. The pipeline code is provided; avoid reviewing tool internals or the biology of each file in detail
    - Realistic benchmarking. The data is deliberately tiny, so resource differences are small and some failures (out-of-memory, walltime exceeded) won't occur. Keep reminding learners that the **practice** is what transfers to real data

??? note "The development loop across lessons"

    Each lesson (2.1–2.7) follows the same cycle, which mirrors how learners should approach their own pipelines:

    1. **Run** the pipeline with the current configuration
    2. **Inspect** what happened: error messages, work directories, trace files, timelines
    3. **Change** one thing: a config option, a resource request, or (only where needed for performance) module or workflow code
    4. **Re-run** and compare

    Name this loop explicitly at the start of Part 2 and refer back to it in each lesson. The recurring message is: start small, measure, optimise, then scale.

!!! warning "Two systems, different results"

    As in Part 1, every step is presented in synced Gadi (PBS Pro) and Setonix (Slurm) tabs. In Part 2, the two systems sometimes **behave differently**, not just use different syntax. For example, the `GENOTYPE` process fails on Gadi but succeeds on Setonix in 2.1. If rerunning these materials again on NCI and Pawsey, point these differences out when they happen; they're good illustrations of why configuration must be system-specific.

## 2.0 Introduction

This lesson gets learners logged back in and oriented to the custom pipeline in `part2/`. You will introduce:

- The scenario: the same WGS short variant calling workflow as Part 1, now as a custom pipeline (`FASTQC` → `ALIGN` → `GENOTYPE` → `JOINT_GENOTYPE` → `STATS` → `MULTIQC`)
- The pipeline file anatomy: `main.nf`, `modules/`, `nextflow.config`, and the system-specific configs in `config/`
- Why logic and configuration are kept separate, and that most of Part 2 will edit config files, not module code
- The warning that the data is small, so some behaviours seen on real data won't appear

- Learners should be able to read `main.nf` at a high level. Don't walk through every channel operator; point out where data enters (the samplesheet), how processes are connected, and where samples are gathered (`groupTuple`, `collect`)
- Remind learners that the pipeline is intentionally unoptimised, "like something developed and run on a laptop"
- Learners will be in a new folder (`part2/`). Make sure they `cd` or open the right directory in VSCode before starting 2.1

## 2.1 Running a custom pipeline on HPC

This lesson takes the pipeline from failing out of the box to running on the scheduler. It is deliberately iterative: run, fail, diagnose, configure, run again. Budget the full 30 minutes, as each run takes a few minutes.

Your main aim is for learners to practise **reading a failure and deciding what to configure next**. You can do this by:

- Asking learners to diagnose the first failure themselves using the terminal output, `.nextflow.log`, and the `.command.*` files in the failed task's work directory before revealing the answer (exit status 127, command not found)
- Making the point after the second run that it succeeded but **everything ran on the login node** (`executor > local`). A successful run is not necessarily a correct one
- Connecting each config addition back to Part 1: `module` and `singularity {}` (1.2, 1.8), `executor` and `queue` (1.5, 1.8), `clusterOptions`, `storage`, `cache`, and `stageInMode` (1.8)
- Introducing the three configuration files and their roles: `nextflow.config` (workflow), `pbspro.config`/`slurm.config` (system), `custom.config` (run-level resources)

!!! warning "Gadi learners will see a failure that Setonix learners won't"

    After adding the executor, Gadi's `GENOTYPE` task fails with exit status 247 because the default 512 MB memory isn't enough, while Setonix's default (about 1.8 GB) is. Use this as the motivation for explicit resource configuration: test data that runs with defaults can fail on real data, or on a different system.

??? note "Finding the scheduler job ID"

    Learners use `grep -w GENOTYPE .nextflow.log | grep jobId` to find the job ID, then `qstat -xf` or `seff`. Show where the job ID sits in the log line. This is the manual version of what the trace file's `native_id` field will give them in 2.2.

??? note "Running the head job on the login node"

    As in Part 1, learners run `nextflow run` on the login node for simplicity. The lesson's opening warning recommends interactive jobs for testing, and persistent sessions (Gadi) or workflow nodes (Setonix) for real runs. Repeat this explicitly; learners leaving Part 2 to run their own pipelines need to hear it.

## 2.2 Pipeline monitoring and reporting

This lesson introduces Nextflow's built-in profiling: execution reports and timelines, `nextflow log`, and trace files, all configured in `custom.config`.

The key idea to communicate is that **resource requirements can't be "set and forget"**: they vary with data size, data type, and system, so you need visibility at the process level to tune them.

- Explain why reports are configured in a config file rather than with `-with-report`/`-with-timeline` on the command line: they're always generated, and the timestamped filenames prevent overwrites
- Have learners download and open the HTML report in their local browser. VSCode's right-click "Download" works on the remote files
- Point out the small naming differences between `nextflow log` fields and trace fields (`pcpu` vs `%cpu`, `pmem` vs `%mem`). Read the docs!
- When adding `workdir` and `native_id` to the trace, emphasise how much faster debugging becomes when every task row links to its work directory and scheduler job

??? note "Don't delete `.nextflow.log` files"

    `nextflow log` reads run history from the `.nextflow.log*` files in the launch directory. Learners who clean up their directory between runs will lose this history. Mention it before they start tidying.

??? note "Trace files and `-resume`"

    Learners may expect a resumed run's trace to only include tasks that re-ran. It includes every task, including cached ones (marked `CACHED`), so the latest trace is always a complete record of the run.

This lesson adds `-resume` to `run.sh`. Remind learners to keep track of whether their run script currently has `-resume`, because 2.5 removes it and later adds it back.

## 2.3 Optimising Nextflow for HPC

This is a short lecture and discussion that frames the rest of Part 2: why, when, and what to optimise.

- Give reasons beyond cost: queue time, fair use of a shared system, the environmental footprint of compute, and being able to show in grant applications that compute was used efficiently
- Optimisation pays off most for large datasets, repeated runs, SU-charged systems, and data-dependent resource use. A pipeline run once on a few samples may not be worth heavy tuning
- Reinforce that **resource efficiency always applies, but parallelisation only applies where it is biologically valid**. Use the read alignment example (reads are independent, so splitting is valid) and contrast it with joint genotyping
- Walk through the three factors (the HPC system, the data, the workflow structure) and preview what Part 2 will optimise: process resources (2.4), multi-threading and scatter-gather (2.5), and scaling by sample (2.7)

## 2.4 Assigning process resources

This lesson uses trace data and node hardware to choose resources per process, applies them with `withName`, and shows that tools must be told to use the CPUs they're given (`${task.cpus}`).

Your main aim is for learners to grasp two connected ideas:

1. **Request resources that fit the node.** Compute the effective memory per core (node memory ÷ cores) for the queue and size requests around it
2. **Allocating resources is not enough.** The process script must pass them to the tool, or the cores sit idle

You can do this by:

- Working through the "memory per core" exercise together, using each system's queue documentation. Gadi `normalbw` has mixed 128 GB and 256 GB nodes, which is a good example of why to size for the smaller node
- Discussing the trade-off in the lesson: requesting your full memory entitlement costs nothing extra but may queue longer; requesting less may slot in sooner
- Asking learners which config file the resource requests belong in before revealing the answer (`custom.config`: they're both system-specific and data-specific)
- Letting learners spot the hard-coded `fastqc -t 1` themselves after seeing ~90% CPU on a 2-core task, then fix it with `-t ${task.cpus}` and confirm close to 200%

??? note "`withName` vs. `withLabel`"

    `withName` targets processes by name and supports regular expressions (e.g. `/FASTQC|ALIGN|JOINT_GENOTYPE/`), so resources can be tuned without editing module code to add labels. It also has higher priority than `withLabel`. Learners who've seen nf-core's `withLabel:process_medium` in Part 1 may ask why we don't use labels here; this is the answer.

??? note "Reading `%cpu`"

    Clarify that `%cpu` is per task, not per core: 100% means one core fully used, 200% means two. Learners often read 90% on a 2-core task as "nearly perfect" when it means one core was idle.

??? note "Hard-coding values in modules"

    Use the `fastqc -t 1` example to make the general point: never hard-code resource values (threads, memory) in a module's script. Use `task.cpus`, `task.memory`, and so on, so the same module works with whatever the config requests.

## 2.5 Parallelisation

This is the longest lesson in Part 2 (60 minutes) and has the most code changes. It covers multi-threading `bwa mem`, then building a scatter-gather pattern around alignment. Use the code checkpoints generously: learners who fall behind should copy the checkpoint code and continue rather than debug a broken `main.nf`.

### Multi-threading

- Use the benchmarking table to discuss diminishing returns: walltime keeps dropping with more cores, but CPU efficiency falls. A target of >80% efficiency is a reasonable rule of thumb
- Run the poll questions (how many cores, which config file, how much memory) before showing answers
- Point out that `ALIGN` already uses `-t $task.cpus`, so only the config needs to change

!!! warning "The `-resume` switch"

    After changing `ALIGN`'s resources, the run is fully cached, so learners then remove `-resume` and re-run from scratch to see the new resources take effect. Later, the advanced troubleshooting exercise asks them to add `-resume` back. Learners lose track of this, so state the current expected state of `run.sh` at each step.

### Scatter-gather

Your main aim is for learners to see that **Nextflow handles the orchestration once the channels are right**. Splitting into 3 chunks automatically creates 3 `ALIGN` tasks, and they inherit the configured resources with no extra code.

Build it in the order the lesson does, and let each error motivate the next step:

1. **Scatter** with `.splitFastq(limit: 3, pe: true, file: true)` and inspect with `.view()`
2. **Error: file name collision** in `JOINT_GENOTYPE`, because all three chunks produce `NA12877.g.vcf.gz`. The advanced exercise uses `GENOTYPE.out.view()` to show this
3. **Add a `chunk_id`** to the tuple and to the `ALIGN` output names so each chunk's BAM is unique
4. **Expected failure:** the workflow still expects one BAM per sample. Ask learners to predict why before moving on
5. **Gather** with `.groupTuple()` and `MERGE_BAMS`, then inspect the `MERGE_BAMS` work directory to confirm the three BAMs were merged

??? note "Optional advanced troubleshooting task"

    The "Advanced exercise: Troubleshoot `GENOTYPE` error" is optional. If time is short, demonstrate it yourself or simply explain the collision and move straight to adding the `chunk_id`.

??? note "How `chunk_id` is extracted"

    The lesson uses `r1.toString().tokenize('.')[2]`, which splits the **full path** on dots. This only works if no directory in the path contains a dot. If a learner's username or path contains a `.`, the chunk ID will be wrong. Using the file name only (e.g. `r1.name.tokenize('.')[2]`) avoids this. Mention it if anyone hits unexpected chunk IDs.

??? note "Not everything should be split"

    Revisit the biological validity point from 1.4: alignment can be split because reads are independent, but joint genotyping can't. Note that `GENOTYPE` could also be parallelised by genomic interval, but that is out of scope.

??? note "Dynamic resourcing"

    The closing section on `task.attempt` retries and input-size-based resources is lecture-only. Present it briefly as "where to go next" for heterogeneous real datasets, and point to the Nextflow training links.

## 2.7 Scale to multiple samples

This lesson shows that the optimised pipeline scales to all three samples by changing only the samplesheet. It's short (10 minutes), so keep it focused.

- Make the key point explicit: **scaling is a configuration problem, not a coding problem**. Nothing in `main.nf` or the modules changes
- Use `-resume` so the sample already processed isn't re-run
- Have learners open the timeline and identify the three kinds of parallelism: parallel by sample (`FASTQC`, `MERGE_BAMS`, `GENOTYPE`), scattered within a sample (`ALIGN`, 3 chunks × 3 samples), and run once for the whole cohort (`JOINT_GENOTYPE`, `STATS`, `MULTIQC`)
- Explain how to read the timeline for problems, e.g. scattered tasks running one after another instead of together, which suggests a resource or channel issue

??? note "Before running at full scale"

    Learners planning to take this home should check:

    - Their project has enough service units. Use benchmark trace data to estimate
    - Their scratch storage **and inode** quotas can hold the outputs. The lesson suggests extrapolating from benchmarks and multiplying by about 1.2–1.5
    - Outputs are scientifically correct on a few full-sized samples (out of scope here, but critical)

## Summary and takeaways

A short instructor-led recap and Q&A (10 minutes). Use the takeaway headings in the lesson as your structure: know your HPC, start small then scale, use Nextflow's profiling, choose the right optimisation strategy, and iterate. Highlight two points in particular:

- **Reach out to your HPC support team.** They're the best source of system-specific optimisation advice
- **Separate _what_ the workflow runs from _how_ and _where_ it runs**, with separate config files for each

Finish by pointing to the resources list and the course survey.

## Known issues in the Part 2 materials

Check these before delivery:

- **`cpu` vs `cpus`:** every `custom.config` in 2.1–2.5 sets the default as `cpu = 1`. The directive is `cpus`, so this line has no effect (the `withName` blocks correctly use `cpus`)
- **Setonix `--reservations` typo:** the 2.1.7 code checkpoint for `slurm.config` uses `--reservations=NextflowHPC`; the exercise above it correctly uses `--reservation`. Learners who copy the checkpoint will get a scheduler error
- **Setonix cores per node:** Part 2 uses 128 cores per `work` node (~1.8 GB per core), but Part 1 (1.4.4) uses 64 CPUs per node (~3.5 GB per CPU). Make these consistent
- **2.0:**
    - The login link points to the hosted workshop site rather than the local [setup page](../workshop/setup.md)
    - Two sections are numbered 2.0.3
    - The `tree` output and one bullet refer to `conf/`, but the pipeline uses `config/`
- **2.1:**
    - "NA1287" should be "NA12877"
    - The Gadi Singularity code block is titled `config/pbspro.sh` instead of `config/pbspro.config`
    - Comments in the Setonix `slurm.config` say "pbspro scheduler on the 'normalbw' queue"
- **2.2:**
    - The question refers to `report.html`, but the file is `report-<timestamp>.html`
    - The `-resume` hint only shows the Slurm command
    - "View the previously generated trace file" uses `<newest-timestamp>` twice
    - The trace `fields` differ between the exercise, the hint, and the code checkpoint (`rss` vs `peak_rss`, and `duration` is missing)
- **2.3:** refers to scaling as "Lesson 2.6", but the lesson is numbered 2.7, and there is no 2.6
- **2.4:**
    - The grouping table lists `GENOTYPE` twice and doesn't match the config, which groups `FASTQC|ALIGN|JOINT_GENOTYPE`
    - "The walltime has also increased" should read "decreased"
    - The Gadi code checkpoint drops `workdir,native_id` from the trace fields and has misaligned indentation
- **2.4 vs 2.5 caching:**
    - In 2.4, re-running with `-resume` after changing `withName` resources shows the tasks re-running with the new values
    - 2.5 says configuration changes don't trigger re-runs, and has learners remove `-resume`
    - Confirm the actual behaviour on your Nextflow version so you can explain it consistently
- **2.5:**
    - The `MERGE_BAMS` include block also adds `include { SPLIT_FASTQ } from './modules/split_fastq'`. It isn't used, and the run will fail if that module file doesn't exist
    - The exercise heading says `MERGE_BAM` instead of `MERGE_BAMS`
    - The Setonix config code block is titled `conf/custom.config`
    - The dynamic resourcing example uses `reads.size()`, but `ALIGN`'s inputs are `reads_1` and `reads_2`
- **2.7:**
    - The text says `samplesheets_full.csv`; the file is `samplesheet_full.csv`
    - The example output shows `SPLIT_FASTQ` and `ALIGN_CHUNK` processes, which don't match the pipeline learners built in 2.5 (`.splitFastq` operator, `ALIGN`, `MERGE_BAMS`)
