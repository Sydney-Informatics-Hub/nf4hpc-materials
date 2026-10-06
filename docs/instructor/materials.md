# Workshop materials

This page provides links to the teaching materials used to deliver the *Nextflow for HPC* workshop, along with guidance for trainers using or adapting them.

## Workshop materials

!!! note "Using these materials"

    These pages document the instructor-facing view of the workshop. The participant-facing materials can be viewed in the [workshop materials](../workshop/index.md) section.

    To adapt and deploy the materials for your own delivery, see [the deployment instructions](INSERT-DEPLOYMENT-INSTRUCTIONS-URL).

<!-- Update the links above to match your repository structure. -->

The workshop materials provide hands-on experience configuring, running, and troubleshooting Nextflow workflows on HPC systems. They build on learners’ existing Nextflow knowledge, with a focus on scheduler integration, resource allocation, containerised software environments, and scalable execution.

The aim is to introduce practical HPC workflow execution and the Nextflow features most useful for this setting. Adapt system-specific instructions to the HPC environment used for your delivery.

### Workshop resources

<!-- Add links to the resources used in your workshop. Remove unused rows. -->

| Resource | Link |
| -------- | ---- |
| Participant-facing lessons | [Workshop materials](../workshop/index.md) |
| Workshop code and example workflows | [Insert link](INSERT-CODE-URL) |
| Training data | [Insert link or access instructions](INSERT-DATA-URL) |
| HPC configuration and submission scripts | [Insert link](INSERT-CONFIGURATION-URL) |
| Presentation slides | [Insert link](INSERT-SLIDES-URL) |
| Completed examples and troubleshooting logs | [Insert link](INSERT-EXAMPLES-URL) |

## Trainer guidance

Connect the technical content to practical research needs, such as processing multiple samples, choosing appropriate resources for analysis tasks, and recovering from failed runs.

When teaching, it may help to emphasise:

- How the main Nextflow job submits individual workflow tasks to the HPC scheduler
- How configuration separates workflow logic from infrastructure-specific settings
- How CPU, memory, and walltime requests affect scheduling and task execution
- How containers support reproducibility within local HPC constraints
- How logs and execution reports help learners diagnose problems
- How caching and resume support recovery without repeating completed work

Clearly distinguish general Nextflow concepts from settings specific to the training system. Explain which configuration values learners will need to change when moving to another HPC environment.

Allow time for learners to inspect submitted jobs, interpret task failures, and discuss resource choices. Keep completed outputs and logs available so demonstrations can continue if jobs are delayed.

## Adapting the materials

Before delivering the workshop on another HPC system:

- Update scheduler, queue, project/account, and resource settings
- Review instructions for running the main Nextflow job against local HPC policy
- Update filesystem paths, container settings, and software-loading commands
- Check that all exercises work with the selected software versions
- Test the workflows on compute nodes using participant-equivalent access
- Update screenshots, example outputs, and troubleshooting guidance where needed

See [Training environment](environment.md) for setup requirements and [Training logistics](logistics.md) for delivery considerations.

## Notes from previous trainers

Use the lesson guides below to record teaching notes, common questions, anticipated errors, and suggestions from previous deliveries.

<!-- Replace the titles and filenames with your actual workshop parts.
     Remove the cards until the corresponding guide pages exist. -->

<div class="grid cards" style="grid-template-columns: repeat(2, 1fr);" markdown>

-   :material-puzzle:{ .lg .middle } **Part 1 - [Title]**

    ---

    [:octicons-arrow-right-24: Teaching notes and delivery guidance](pt1-guide.md)

-   :fontawesome-solid-hand:{ .lg .middle } **Part 2 - [Title]**

    ---

    [:octicons-arrow-right-24: Teaching notes and delivery guidance](pt2-guide.md)

</div>