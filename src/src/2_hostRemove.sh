#!/usr/bin/bash

threads=$1
extension=$2
bowtieDB=$3

echo "--------------------- METAPIPELINE [PASO 2]:--------------------------------------"
echo "                          Remove Host                                           "
echo "----------------------------------------------------------------------------------"

#Usage: 
#  bowtie2 [options]* -x <bt2-idx> {-1 <m1> -2 <m2> | -U <r> | --interleaved <i> | -b <bam>} [-S <sam>]

#  <bt2-idx>  Index filename prefix (minus trailing .X.bt2).
#             NOTE: Bowtie 1 and Bowtie 2 indexes are not compatible.
#  <m1>       Files with #1 mates, paired with files in <m2>.
#             Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).
#  <m2>       Files with #2 mates, paired with files in <m1>.
#  -p/--threads <int> number of alignment threads to launch (1)

cd results/
for file in ../raw-reads/*_1.$extension;
    do
        base=$(basename ${file} _1.$extension)
        folder="${base%%_*}"
        echo "host remove"
        R1=$folder\_1.trim.fq.gz
        R2=$folder\_2.trim.fq.gz


        bowtie2 \
        -p $threads \
        -x $bowtieDB \
        -1 trimmed-reads/$folder/$R1 \
        -2 trimmed-reads/$folder/$R2 \
        -S host_removed/${folder}/${folder}_results.sam \
        > host_removed/${folder}/bowtie2_verbose.txt

        #Conversion sam file to bam file
        samtools \
        view \
        -bS host_removed/$folder/${folder}_results.sam \
        --threads $threads \
        > host_removed/$folder/${folder}_results.bam 

        #Filter unmapped reads
        samtools \
        view -b -f 13 -F 256 \
        host_removed/$folder/${folder}_results.bam \
        --threads $threads\
        > host_removed/$folder/${folder}_bothEndsUnmapped.bam 

        #Sort BAM file
        samtools sort -n -@ $threads \
        host_removed/$folder/${folder}_bothEndsUnmapped.bam \
        -o host_removed/$folder/${folder}_sorted.bam

        #Split pared-end reads into separated fastq files
        samtools fastq -@ $threads host_removed/$folder/${folder}_sorted.bam \
                -1 host_removed/$folder/${folder}_host_removed_R1.fastq.gz \
                -2 host_removed/$folder/${folder}_host_removed_R2.fastq.gz \
                
        rm host_removed/${folder}/${folder}_results.sam
        rm host_removed/$folder/${folder}_results.bam
        rm host_removed/$folder/${folder}_bothEndsUnmapped.bam 
        gzip -9 host_removed/$folder/${folder}_sorted.bam
        done
cd ..