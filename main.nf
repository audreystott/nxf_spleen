// Define default parameters

params.genome = "/data/references/GRCh38.p12.fa"
params.annotation = "/data/references/GRCh38.p12.gtf"
params.readspath = "/data/human/spleen/nxf_spleen/raw_data/"
params.reads = "/data/human/spleen/nxf_spleen/raw_data/HCATisStabAug177078016_S1_L001_R*_001.fastq.gz"
params.results - "/data/human/spleen/nxf_spleen/results"

// Parse input parameters

genome_file = file(params.genome)
annotation_file = file(params.annotation)
readspath_ch = Channel.from(params.readspath)
Channel.fromFilePairs(params.reads)
       .into{reads_ch; reads_ch2}

// Process 1 Quality check of reads with fastQC

process 1_fastQC {
    input:
        tuple val(sampleId), file(reads) from reads_ch
    
    output:
        file "*_fastqc.{zip,html}" into fastqc_ch

    script:

        """
        fastqc $reads -o .
        """
}
// Process 2 Pre-processing of reads with CellRanger

process 2_preprocessing {
    input:
        tuple val(sampleId), file(reads) from reads_ch2
        file genome from genome_file
        file annotation from annotation_file
        file readspath from readspath_ch

    output:
        file "/data/human/spleen/nxf_spleen/spleen/outs/filtered_feature_bc_matrix" into cellranger_ch

    script:

        """
        bash cellranger.sh
        cellranger mkref --genome=GRCh38_2 \
                      && --fasta=$genome \
                      && --genes=$annotation
        cellranger count --id=spleen \
                      && --transcriptome=GRCh38_2 \
                      && --fastqs=$readspath \
                      && --sample=$reads
        """
}

// Process 3 Post-processing of count table with Seurat

process 3_postprocessing {
input:
        file matrix from cellranger_ch

    output:
        file "/data/human/spleen/nxf_spleen/spleen/UMAP.png" into cellranger_ch

    script:

        """
        spleen.R
        """
}