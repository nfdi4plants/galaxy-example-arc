class: Workflow
cwlVersion: v1.2
requirements:
  - class: MultipleInputFeatureRequirement
inputs:
  - id: Input1
    type:
      items: File
      type: array
outputs:
  - id: out_dir
    outputSource: planemo/out_dir
    type: Directory
steps:
  - id: preprocessing
    in:
      - id: Input1
        source: Input1
    out:
      - paramFile
      - inputDataFolder
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      requirements:
        - class: InlineJavascriptRequirement
        - class: ShellCommandRequirement
        - class: DockerRequirement
          dockerFile:
            $include: ./dockerfiles/cwl-galaxy-parser/Dockerfile
          dockerImageId: cwl-galaxy-parser
      baseCommand: cwl-galaxy-parser
      inputs:
        - id: Input1
          type:
            items: File
            type: array
            inputBinding:
              prefix: '--file Input1'
              shellQuote: false
      outputs:
        - id: paramFile
          type: File
          outputBinding:
            glob: $(runtime.outdir)/galaxyInput.yml
        - id: inputDataFolder
          type: Directory
          outputBinding:
            glob: $(runtime.outdir)
  - id: planemo
    in:
      - id: workflowInputParams
        source: preprocessing/paramFile
      - id: inputDataFolder
        source: preprocessing/inputDataFolder
    out:
      - out_dir
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      requirements:
        - class: InitialWorkDirRequirement
          listing:
            - entryname: inputDataFolder
              entry: $(inputs.inputDataFolder)
            - $(inputs.workflowInputParams)
            - class: File
              location: workflow.ga
            - entryname: history
              entry: '$({class: ''Directory'', listing: []})'
              writable: true
        - class: InlineJavascriptRequirement
        - class: NetworkAccess
          networkAccess: true
        - class: ShellCommandRequirement
      hints:
        - dockerImageId: planemo
          dockerFile:
            $include: ./dockerfiles/planemo-run/Dockerfile
          class: DockerRequirement
      baseCommand:
        - planemo
        - run
      arguments:
        - position: 1
          valueFrom: ./workflow.ga
        - position: 3
          prefix: '--output_directory'
          valueFrom: $(runtime.outdir)/history
        - position: 4
          valueFrom: '--download_outputs'
        - position: 5
          prefix: '--engine'
          valueFrom: external_galaxy
        - position: 6
          prefix: '--galaxy_url'
          valueFrom: $ARC_GALAXY_URL
          shellQuote: false
        - position: 7
          prefix: '--galaxy_user_key'
          valueFrom: $ARC_GALAXY_API_KEY
          shellQuote: false
      inputs:
        - id: inputDataFolder
          type: Directory
        - id: workflowInputParams
          type: File
          inputBinding:
            position: 2
      outputs:
        - id: out_dir
          type: Directory
          outputBinding:
            glob: $(runtime.outdir)/history
