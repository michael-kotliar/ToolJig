cwlVersion: v1.1
class: CommandLineTool
doc: |-
  Sort a BAM file.
requirements:
  ShellCommandRequirement: {}
  DockerRequirement:
    dockerImageId: 04_sort_bam
    dockerFile: |-
      FROM quay.io/biocontainers/samtools:1.3--h0592bc0_3
  NetworkAccess:
    class: NetworkAccess
    networkAccess: true
inputs:
  bam_file:
    type: File
    doc: |-
      BAM file to be sorted.
  threads:
    type: int
    doc: |-
      The number of threads that samtools should use when sorting.
  sorted_bam_file:
    type: string
    doc: |-
      Name of the sorted BAM file that will be created.
arguments:
    - shellQuote: false
      valueFrom: |-
        samtools sort -@ $(inputs.threads) -o "$(inputs.output_file_name)" "$(inputs.bam_file.path)"

        sambamba index -@ $(inputs.threads) "$(inputs.output_file_name)"
outputs:
  output_files:
    type:
      type: array
      items: File
    outputBinding:
      glob: "$(inputs.sorted_bam_file)*"
  standard_output:
    type: stdout
  standard_error:
    type: stderr
stdout: output.txt
stderr: error.txt
