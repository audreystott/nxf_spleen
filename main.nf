// Define default parameters

params.genome = "/data/references/GRCh38.p12.fa"
params.annotation = "/data/references/GRCh38.p12.trimmed.gtf"
params.reads = "raw_data/HCATisStabAug177078016_S1_L001_R{1,2}_001.fastq.gz"
params.results = "results"
params.cellrangerURL = "cellranger_url.txt"
params.readsdir = "raw_data/"

// Parse input parameters

genome_file_ch = Channel.fromPath(params.genome)
annotation_file_ch = Channel.fromPath(params.annotation)
cellrangerURL_file = file(params.cellrangerURL)
Channel.fromFilePairs(params.reads)
       .into{reads_ch; reads_ch2}
reads_dir_ch = Channel.fromPath(params.readsdir)

// Process 1 Quality check of reads with fastQC

process fastQC {
    input:
        tuple val(sampleId), path(reads) from reads_ch
    
    output:
        file "*_fastqc.{zip,html}" into fastqc_ch

    script:
        """
        fastqc $reads -o .
        """
}

// Process 2 Pre-processing of reads with CellRanger

process mkref {
    input:
        path genome from genome_file_ch
        path annotation from annotation_file_ch
        file crurl from cellrangerURL_file

    output:
        path "GRCh38/" into mkref_ch

    script:

        """
        cellranger mkref --genome=GRCh38 --fasta=$genome --genes=$annotation
        """
}

process count {
    input:
        path reads from reads_dir_ch
        path genomepath from mkref_ch

    output:
        file "HCAT/outs/filtered_feature_bc_matrix" into count_ch

    script:

        """
        cellranger count --id=HCAT --transcriptome=$genomepath \
                         --fastqs=$reads --sample=HCATisStabAug177078016
        """
}

// Process 3 Post-processing of count table with Seurat

process seurat {
    publishDir params.results
    
    input:
        file matrix from count_ch

    output:
        file "spleen_UMAP.png" into results

    script:

        """
        spleen.R
        """
}