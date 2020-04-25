cwlVersion: v1.1
class: CommandLineTool
doc: |-
  Align FASTQ files to a reference genome using the Burrows-Wheeler Aligner software (bwa mem). This is designed for paired-end reads stored in two separate FASTQ files.
requirements:
  ShellCommandRequirement: {}
  DockerRequirement:
    dockerImageId: 03_align_bwa_mem
    dockerFile: |-
      FROM biocontainers/biocontainers:v1.0.0_cv4
      RUN conda install -c bioconda/label/cf201901 bwa samtools -y
  NetworkAccess:
    class: NetworkAccess
    networkAccess: true
inputs:
  ref_genome_dir:
    type: Directory
    doc: |-
      Directory containing reference genome FASTA file and index files.
  ref_genome_fasta_name:
    type: string
    doc: |-
      Name of the FASTA file containing the reference genome.
  fastq_file_1:
    type: File
    doc: |-
      The first FASTQ file.
  fastq_file_2:
    type: File
    doc: |-
      The second FASTQ file.
  threads:
    type: int
    doc: |-
      The number of threads that BWA should use during alignment.
  read_group_string:
    type: string
    doc: |-
      This argument allows you to specify read-group information during alignment. Please specify the whole read-group string, including the @RG prefix, surround in quotes. You can find a helpful tutorial here: https://software.broadinstitute.org/gatk/documentation/article.php?id=6472.
  args:
    type: string
    doc: |-
      Additional arguments that will be passed through to bwa mem. Example value: "-k 15".
  output_file_name:
    type: string
    doc: |-
      Name of the BAM file that will be created.
arguments:
    - shellQuote: false
      valueFrom: |-
        bwa mem -t $(inputs.threads) $(inputs.args) -R "$(inputs.read_group_string)" "$(inputs.ref_genome_dir.path)/$(inputs.ref_genome_fasta_name)" "$(inputs.fastq_file_1.path)" "$(inputs.fastq_file_2.path)" | samtools view -b > "$(inputs.output_file_name)"
outputs:
  output_file:
    type: File
    outputBinding:
      glob: "$(inputs.output_file_name)"
    doc: |-
      Here we indicate that an output file matching the name specified in the inputs should be generated.
  standard_output:
    type: stdout
  standard_error:
    type: stderr
stdout: output.txt
stderr: error.txt
