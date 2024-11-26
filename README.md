# Metagenomics

In this repository is the pipeline for metagenomic analysis of samples for the CONACYT project 319773: 

***"Producción de biocombustibles para uso rural a partir de desechos agropecuarios mediante la optimización de consorcios microbianos usando metagenómica"***  

*"Production of biofuels for rural use from agricultural waste by optimization of microbial consortia using metagenomics"*

This pipeline is based on Garfias-Gallegos *et al.*, (2022) Methods in Molecular
Biology, vol.2512 https://doi.org/10.1007/978-1-0716-2429-6_10,

and

Saenz *et al.*, (2022). MIntO: a modular and scalable pipeline for microbiome metagenomic and metatranscriptomic data integration. Frontiers in Bioinformatics, 2, 846922, with modifications, 
and maintained by the [Bioinformatics & complex networks lab](https://ira.cinvestav.mx/ingenieriagenetica/dra-maribel-hernandez-rosales/bioinformatica-y-redes-complejas/) at CINVESTAV Irapuato 
 
## Pipeline Overview

![My Image](doc/pipeline.png)

Briefly, the pipeline is divided into the following modules, which perform the following analyses:

**1) Quality Control and Cleaning:**

A quality report before and after read cleaning is generated using the FastQC tool. Trimmomatic is used to remove adapters from the reads and trim low-quality ends.

**2) Host Read Cleaning:**

Sequences mapping to the reference of host genomes are removed.

**3) Taxonomic Assignment of Reads:**

Kraken2 is used to assign a taxonomic identity to each read, and the quantification of reads per organism per sample is performed to report relative abundance as well as alpha and beta diversity of the processed samples.

**4) Metagenome Assembly and MAG Construction:**

metaSPAdes is used to assemble reads into contigs, and the contigs are grouped into bins with MaxBin2. These bins are referred to as MAGs (Metagenome-Assembled Genomes).

**5) Taxonomic Classification of MAGs:**

The PhyloPhlAn tool is used to perform the taxonomic classification of the genomes ensambled from the reads.

**6) Gene Annotation:**

Within each MAG, open reading frames are identified and annotated using the Prokka tool. The search is performed based on the taxonomic classification of the MAG in the previous step (bacteria, archaea, or virus).

**7) Functional Annotation:**

The open reading frames identified in the previous step are analyzed to identify similarities with other metabolic genes and annotated with KEGG terms using the eggNOG-Mapper and KofamScan tools.

## Github Content:

- **install**: Contains a raw file listing the software needed for this pipeline and the instructions for installing it. More detail info on installation is available on the User´s manual.
- **doc**: Contains the Users manual for the pipeline as well as repository images of the pipeline´s flowchart.
- **src**: Contains the scrips for running the pipeline up until taxonomic assignment. For `botanero.cs.cinvestav.mx`server users, a copy of this folder can be found at `/home/metagenomics/projects/biodigestores/metaPipeline`
- **analysis-r**: Contains the script necessary for running the abundance and diversity analysis on local computer (.Rmd), as well as a compiled tutorial on pdf.

