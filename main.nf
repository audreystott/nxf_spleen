// User to set these variables

genome_ref = "GRCh38"
genome_ref_file_path = "/data/references/GRCh38.p12.fa"
annotation_file_path = "/data/references/GRCh38.p12.trimmed.gtf"
read_id = "HCATisStabAug177078016"
read_short_name = "HCAT"
reads_dir = "raw_data/"
species_id = "spleen"

// Define default parameters

params.reads = "${reads_dir}/*R{1,2}*.fastq.gz"
params.results = "results"
params.cellrangerURL = "cellranger_url.txt"

// Parse input parameters

genome_file_ch = Channel.fromPath(genome_ref_file_path)
annotation_file_ch = Channel.fromPath(annotation_file_path)
cellrangerURL_file = file(params.cellrangerURL)
Channel.fromFilePairs(params.reads)
       .into{reads_ch; reads_ch2}
reads_dir_ch = Channel.fromPath(reads_dir)

// Process 1 Quality check of reads with fastQC

//process fastQC {
//    input:
//        tuple val(sampleId), path(reads) from reads_ch
    
//    output:
//        file "*_fastqc.{zip,html}" into fastqc_ch

//   script:
//        """
//        fastqc $reads -o .
//        """
//}

// Process 2 Pre-processing of reads with CellRanger

process mkref {
    input:
        path genome from genome_file_ch
        path annotation from annotation_file_ch

    output:
        path "${genome_ref}/" into mkref_ch

    script:

        """
        cellranger mkref --genome=$genome_ref --fasta=$genome --genes=$annotation
        """
}

process count {
    input:
        path reads from reads_dir_ch
        path genomepath from mkref_ch

    output:
        file "${read_short_name}/outs/filtered_feature_bc_matrix" into count_ch

    script:

        """
        cellranger count --id=$read_short_name --transcriptome=$genomepath \
                         --fastqs=$reads --sample=$read_id
        """
}

// Process 3 Post-processing of count table with Seurat

process seurat {
    publishDir params.results
    
    input:
        file matrix from count_ch

    output:
        file "${species_id}_UMAP.png" into results

    script:

        """
        ${species_id}.R
        """
}