This page outlines how the workshop can be organised and delivered in different contexts.

The workshop material can be adapted for the following delivery styles:

-   online
-   in-person
-   hybrid
-   self-paced

## Workshop structure and suggested timing

The goal of this workshop is to teach Nextflow best practices in real-life experimental settings. 

Whilst there is a lot of technical information that needs to be covered in detail, remember to tie it back to the biology, your audience are biological scientists and bioinformaticians that need to use Nextflow to process data and run analyses for their research or applied goals. 

Suggested timings for each module are provided below and can be adapted to suit local needs, learner experience, and delivery mode.

The workshop material is organised into two parts:

=== "Part 1 - **Conceptual HPC foundations**"

    Introduces the core concepts of Nextflow pipeline development and provides learners with the foundational knowledge needed to begin building and customising workflows.

    ### Part 1 - Conceptual HPC foundations and running nf-core on HPC

    | Lesson                                   | Teaching Objective                                                          | Learning Outcome                                                                                          | Learning Experience                                                        | Approx. Time |
    | ---------------------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | ------------ |
    | **1.0 Introduction**                     | Get learners logged in and set up on their HPC                     | Learners can log in to the HPC, set up the workspace, and navigate to the working directory       | Guided setup with facilitator troubleshooting support                      | 15 min       |
    | **1.1 HPC for bioinformatics workflows** | Introduce HPC and when bioinformatics workflows need it                     | Learners can describe what an HPC is, recognise when a workflow needs one, and name its main constraints  | Lecture and discussion, introducing a Whole Genome Sequencing (WGS) variant calling scenario       | 15 min       |
    | **1.2 Software is different on HPC**     | Explain how software is installed and accessed on shared systems            | Learners can load software with modules and run a tool inside a Singularity container                     | Demonstration and code-along running `fastqc` with modules and containers  | 15 min       |
    | **1.3 HPC architecture**                 | Describe the HPC components that workflows interact with                    | Learners can tell login nodes from compute nodes, define job resource requests, and submit a scheduler job | Conceptual walkthrough (scheduler Tetris) and hands-on job submission      | 25 min       |
    | **1.4 Work smarter, not harder!**        | Introduce resource-aware job design                                         | Learners can inspect job resource usage, right-size requests, and tell multi-threading from scatter-gather | Exercise inspecting a previous job, followed by a concept-focused lecture  | 20 min       |
    | **1.5 Running Nextflow on HPC**          | Connect HPC principles to how Nextflow executes tasks                       | Learners can run a workflow on compute nodes using executors, queues, profiles, and the `work/` directory | Code-along running a simple workflow on the scheduler with profiles        | 15 min       |
    | **1.6 Intro to nf-core**                 | Introduce the nf-core community and its pipelines                           | Learners can find nf-core pipelines and recognise the structure of `nf-core/sarek`                        | Lecture and guided tour of the nf-core website and pipeline docs           | 10 min       |
    | **1.7 Running nf-core on HPC**           | Show what is needed to launch an nf-core pipeline                           | Learners can write a run script for `nf-core/sarek` and see why HPC-specific configuration is needed      | Samplesheet walkthrough and code-along writing a run script                | 15 min       |
    | **1.8 Configuring nf-core**              | Build an HPC configuration for an nf-core pipeline                          | Learners can define the executor, Singularity settings, and resource-based queue selection in a config    | Guided exercises building a custom config step by step                     | 30 min       |
    | **1.9 Layering Nextflow configurations** | Explain configuration priorities and process-level fine-tuning              | Learners can layer config files, use `withName` to tune processes, and scale to multiple samples          | Code-along fine-tuning `nf-core/sarek`, then a multi-sample run            | 15 min       |
    | **1.10 Summary**                         | Consolidate Part 1 takeaways                                                | Learners can recall the key HPC and Nextflow principles covered and how they lead into Part 2             | Instructor-led recap and Q&A                                               | 5 min        |

=== "Part 2 - **Hands-on workflow deployment on HPC**"

    Provides hands-on practice in creating a scalable multi-sample Nextflow workflow for RNA-seq data preparation.

    ### Part 2 - Hands-on pipeline configuration and optimisation on HPC

    | Lesson                                        | Teaching Objective                                                     | Learning Outcome                                                                                              | Learning Experience                                                            | Approx. Time |
    | --------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | ------------ |
    | **2.0 Introduction**                          | Set the context for Part 2 and the custom pipeline's structure         | Learners can describe the roles of `main.nf`, `modules/`, and config files, and why logic and configuration are kept separate | Log back in, then an instructor walkthrough of the pipeline file anatomy        | 15 min    |
    | **2.1 Running a custom pipeline on HPC**      | Take a custom pipeline from failing out of the box to running on HPC   | Learners can enable containers, configure the executor and queue, troubleshoot failures, and write a run script | Iterative code-along: run, fail, diagnose, configure, and run again            | 30 min       |
    | **2.2 Pipeline monitoring and reporting**     | Introduce Nextflow's built-in profiling features                       | Learners can produce execution reports, timelines, and trace files, and use `nextflow log` to inspect resource use | Hands-on exercises enabling reports, followed by guided interpretation          | 20 min       |
    | **2.3 Optimising Nextflow for HPC**           | Frame why, when, and what to optimise                                  | Learners can identify the system, data, and workflow factors that affect performance on HPC                   | Lecture and discussion                                                         | 10 min       |
    | **2.4 Assigning process resources**           | Teach resource-aware configuration of individual processes            | Learners can match memory to node hardware, use `withName`, and pass allocated CPUs into process scripts      | Trace-driven exercises tuning `FASTQC` resources                               | 30 min       |
    | **2.5 Parallelisation**                       | Show multi-threading and scatter-gather in practice                    | Learners can multi-thread `bwa mem`, split and merge reads with scatter-gather, and judge when splitting is biologically valid | Guided exercises with code checkpoints and an optional advanced troubleshooting task | 60 min       |
    | **2.7 Scale to multiple samples**             | Show how an optimised pipeline scales without code changes             | Learners can run the pipeline on all samples, sanity-check execution with the timeline, and match HPC allocation to scale | Hands-on multi-sample run and timeline inspection                               | 10 min       |
    | **Summary and takeaways**                     | Consolidate Part 2 and point to further resources                      | Learners can recall the strategy of starting small, profiling, optimising, and then scaling                   | Instructor-led recap and Q&A                                                    | 10 min       |

## Delivery considerations

When planning delivery, trainers should consider:

-   whether the workshop will be run online, in person, or hybrid
-   the number of trainers and facilitators available
-   the learner group’s prior experience with command line tools, workflows, and bioinformatics
-   the time needed for setup, troubleshooting, and hands-on support
-   how questions and discussion will be managed during the session

### Learner support 

A collaborative space can be useful for collecting questions, troubleshooting issues, and sharing links and tips during the workshop. We have used both Slack channels and shared Google Docs to provide learners with this space in previous training events. See: 

- [Shared document template](../assets/template-participant-discussion.docx)

### Trainer support 

A runsheet shared amongst trainers and facilitators can be useful for coordinating responsibilities, tracking timing across sessions, and ensuring a consistent experience for learners. It can include who is presenting each section, when breaks are scheduled, which facilitators are on hand for support, and any notes on pacing or anticipated troubleshooting points. See: 

- [Runsheet template](../assets/template-trainer-runsheet.docx)
