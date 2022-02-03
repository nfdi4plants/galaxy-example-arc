class: Workflow
inputs:
  - id: Input1
    type:
      items: File
      type: array
outputs:
  - id: out_dir
    outputSource: workflow/out_dir
    type: Directory
requirements:
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
cwlVersion: v1.2
steps:
  - id: workflow
    in:
      - id: Input1
        source: Input1
    out:
      - out_dir
    run: ../../workflows/workflow/workflow.cwl
