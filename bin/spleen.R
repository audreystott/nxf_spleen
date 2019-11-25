#!/usr/bin/env Rscript

# Install and load Seurat development mode and dependencies
pip install umap-learn
devtools::install_github(repo = 'satijalab/seurat', ref = 'develop')
library(Seurat)
library(ggplot2)
library(sctransform)

# Define Seurat object
spleen_data <- Read10X(data.dir = )
spleen <- CreateSeuratObject(counts = spleen_data)

# Normalise data
spleen <- PercentageFeatureSet(spleen, pattern = "^MT-", col.name = "percent.mt")
spleen <- SCTransform(spleen, vars.to.regress = "percent.mt", verbose = FALSE)

# Reduce dimensions using PCA and UMAP
spleen <- RunPCA(spleen, verbose = FALSE)
spleen <- RunUMAP(spleen, dims = 1:30, verbose = FALSE)
spleen <- FindNeighbors(spleen, dims = 1:30, verbose = FALSE)
spleen <- FindClusters(spleen, verbose = FALSE)
png("spleen_UMAP.png")
DimPlot(spleen, label = TRUE) + NoLegend()
dev.off()
