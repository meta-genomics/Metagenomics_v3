#!/usr/bin/bash
 #####################################################################
# Usage:                                                
#       1. Correr este script indicando el número de threads. E.g.:
#                       bowtieDB_construction.sh 16 <path_refGenomesList.txt>
#####################################################################

threads=$1
path=$2

echo "-------------------------- METAPIPELINE -----------------------------------------"
echo "                          Bowtie2 DB construction                                "
echo "---------------------------------------------------------------------------------"
 
#1. Create hostDB folder
mkdir bowtieDB
mkdir bowtieDB/ref_genomes

#2. Load references genomes accessions list to botwtieDB folder
#Equus caballus (horse) ACC: GCA_002863925.1
#Bos taurus (cattle) Hereford (breed) ACC: GCA_002263795.3
#Sus scrofa domesticus (domestic pig) Meishan (breed) ACC: 	GCA_017957985.1
#Homo sapiens (human) GRCh38.p14 ACC: GCA_000001405.29
mv $path bowtieDB

#2. Download reference genomes inside ref_genomes folder and set workdir
cd bowtieDB/ref_genomes

bit-dl-ncbi-assemblies -w ../refGenomes_accessions.txt -f fasta -j 1

gzip -d *.gz

#3. Create bowtie2 index databases (hostDB): ------------------------------------------
#Merge reference genomes into one CombinedReference.fa file
cat ref_genomes/*.fa > ref_genomes/CombinedReference.fa ;

#4. Create bowtie2 index databases (hostDB)
#Usage: bowtie2-build [options]* <reference_in> <bt2_index_base>
#    reference_in            comma-separated list of files with ref sequences
#    bt2_index_base          write bt2 data to files with this dir/basename

bowtie2-build -p $threads ref_genomes/CombinedReference.fa hostDB

cd ../..