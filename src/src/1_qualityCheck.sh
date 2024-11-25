#!/usr/bin/bash

threads=$1
extension=$2

echo "--------------------- METAPIPELINE [PASO 1]:--------------------------------------"
echo "                          QUALITY CHECK                                           "
echo "----------------------------------------------------------------------------------"

#1: First quality check: ---------------------------------------------------------------------
# Iterate through the folders
cd results/
for file in ../raw-reads/*_1.$extension;
    do
    base=$(basename ${file} _1.$extension)
    echo $base
    folder="${base%%_*}"
    echo $folder


    fastqc  ../raw-reads/$base*.$extension -o fastqc/beforeTrimQC/$folder/ -t $threads > fastqc/beforeTrimQC/$folder/fastqc_verbose.txt

    #2: Clean the reads: -------------------------------------------------------------------------
    # Usage:
    #       PE [-version] [-threads <threads>] [-phred33|-phred64] [-trimlog <trimLogFile>] 
    #       [-summary <statsSummaryFile>] [-quiet] [-validatePairs] [-basein <inputBase> | <inputFile1> <inputFile2>] 
    #       [-baseout <outputBase> | <outputFile1P> <outputFile1U> <outputFile2P> <outputFile2U>] <trimmer1>...

    R1=$base\_1.$extension
    R2=$base\_2.$extension

    trimmomatic PE ../raw-reads/$R1 ../raw-reads/$R2\
        -threads $threads \
        trimmed-reads/$folder/${folder}_1.trim.fq.gz \
        untrimmed-reads/$folder/${folder}_1.unpaired.fq.gz \
        trimmed-reads/$folder/${folder}_2.trim.fq.gz \
        untrimmed-reads/$folder/${folder}_2.unpaired.fq.gz\
        HEADCROP:20 SLIDINGWINDOW:4:20 MINLEN:35 \
        > trimmed-reads/$folder/trimming_verbose.txt

    #3: Second quality check after trimming: --------------------------------------------------------

    fastqc  trimmed-reads/$folder/*.fq.gz \
            -o fastqc/trimQC/$folder/ -t $threads > fastqc/trimQC/$folder/fastqc_trim_verbose.txt
    done
cd ..
