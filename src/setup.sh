#!/usr/bin/bash
echo "--------------------------METAPIPELINE-----------------------------------"
echo "                       Setup metapipeline                                "
echo "                         Augusto Franco                                  "
echo "-------------------------------------------------------------------------"

function usage {
        printf "Usage:\n"
        printf " -h                                Display this help message.\n"
        printf " -p  <folder path>                 Folder path where the samples are.\n"
        printf " -n  <Prefix for samples>          Prefix of the samples that you will use (e.g. SRR*).\n"
        printf " -wd <folder path>                 Working directory.\n"
        printf " -e  <extension>                   File extension (e.g. fq, fq.gz, fastq, fastq.gz).\n"
        exit 0
}


while getopts :p:n:wd:e:h opt; do
    case ${opt} in
        h)
            usage
            ;;
        p) path=${OPTARG}
            ;;
        n) prefix=${OPTARG}
            ;;
        e) extension="$OPTARG"
            ;;
      *)
          printf "Invalid Option: $1.\n"
          usage
       ;;
     esac
done


mkdir raw-reads
#Copy/move all the fastq files to raw-reads folder

for sample in $path/$prefix*;
do
    substring=${sample##*/}
    # Count the .txt files in the directory
    file_count=$(find "$sample" -maxdepth 1 -type f -name "*.$extension" | wc -l)

    if [ "$file_count" -gt 2 ]; then
        echo "copy samples of $substring"
        cp $sample/$substring\_1.$extension raw-reads/
        cp $sample/$substring\_2.$extension raw-reads/
    else
        echo "copy samples of $substring"
        cp $sample/$substring*_L*_1.$extension  raw-reads/
        cp $sample/$substring*_L*_2.$extension  raw-reads/
    fi
done

mkdir results
mkdir results/checkData
mkdir results/taxonomy
mkdir results/taxonomy/kraken
mkdir results/taxonomy/phylophlan
mkdir results/assemblies
mkdir results/fastqc
mkdir results/fastqc/beforeTrimQC
mkdir results/fastqc/trimQC
mkdir results/trimmed-reads
mkdir results/untrimmed-reads
mkdir results/host_removed
mkdir results/geneAnnotation/
mkdir results/functionalAnnotation/
mkdir results/functionalAnnotation/eggNOG
mkdir results/functionalAnnotation/kofam

#Create folders for each sample
for R1 in raw-reads/$prefix*_1.$extension;
    do
        base=$(basename ${R1} _1.$extension)
        folder="${base%%_*}"
        echo $folder
        mkdir results/taxonomy/kraken/$folder
        mkdir results/taxonomy/phylophlan/$folder
        mkdir results/assemblies/$folder
        mkdir results/fastqc/beforeTrimQC/$folder
        mkdir results/fastqc/trimQC/$folder
        mkdir results/trimmed-reads/$folder
        mkdir results/untrimmed-reads/$folder
        mkdir results/host_removed/$folder
        mkdir results/functionalAnnotation/eggNOG/$folder
        mkdir results/functionalAnnotation/kofam/$folder
    done

