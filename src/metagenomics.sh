#!/usr/bin/bash

#####################################################################
#       PIPELINE PARA EL PROCESAMIENTO DE MUESTRAS METAGENÓMICAS    #
#                       Dulce I. Valdivia                           #
#                       Erika Cruz-Bonilla                          #   
#                       Augusto Franco                              #  
#####################################################################

function usage {
       printf "Usage:\n"
       printf " -h                               Display this help message.\n"
       printf " -t <threads>                     CPUs.\n"
       printf " -e <file extension>              File extension (E.g. fq, fq.gz, fastq.gz, fastq).\n"
       printf " -n <sample prefix>               Sample prefix (E.g. SRR*, Tube, Dome, etc).\n"       
       exit 0
}

while getopts :t:e:n:h opt; do
    case ${opt} in
        h)
            usage
            ;;
        t) threads=${OPTARG}
            ;;
        e) extension="$OPTARG"
            ;;
        n) prefix=${OPTARG}
            ;;
      *)
          printf "Invalid Option: $1.\n"
          usage
       ;;
     esac
done

# SCRIPT 1 ----------------------------------------------------------
# Run:
        ./src/1_qualityCheck.sh $threads $extension $prefix >> metagenomics.log

# SCRIPT 2 ----------------------------------------------------------
# Config:
       bowtieDB="/home/afranco/datos/Metagenomics-main_v3/bowtieDB/ref_genomes/hostDB"
# Run:
       ./src/2_hostRemove.sh $threads $extension $bowtieDB >> metagenomics.log

# SCRIPT 3 ----------------------------------------------------------
# Config:
       dirKrakenDB="/data/dvaldivia_data/krakenDB_PlusPFP_20230314"
# Run:
       ./src/3_taxonomicAssignmentHostRemoved.sh $threads $extension $dirKrakenDB >> metagenomics.log

# SCRIPT 4 ----------------------------------------------------------
# Config:
       export PATH="/home/metagenomics/projects/biodigestores/metaPipeline/lib/SPAdes-3.15.5-Linux/bin:$PATH"
       export PATH="/home/metagenomics/projects/biodigestores/metaPipeline/lib/MaxBin-2.2.7/:$PATH"
       export CHECKM_DATA_PATH="/home/metagenomics/projects/biodigestores/metaPipeline/lib/checkm_data"

# Run:
       ./src/4_metagenomeAssembly.sh $threads $extension $prefix >> metagenomics.log

# SCRIPT 5 ----------------------------------------------------------
# Run:
       ./src/5_taxonomicAssignmentMAGs.sh $threads  >> metagenomics.log

# SCRIPT 6 ----------------------------------------------------------
# Run:
      ./src/6_geneAnnotation.sh $threads $prefix >> metagenomics.log
# SCRIPT 7 ----------------------------------------------------------

# Config:
        eggnogDB="/data/afranco_data/Metagenomics-main_v3/eggnogDB"
        profile="/data/afranco_data/Metagenomics-main_v3/kofamDB/profiles"
        koList="/data/afranco_data/Metagenomics-main_v3/kofamDB/ko_list"
# Run:

        ./src/7_functionalAnnotation.sh $threads $prefix $eggnogDB $profile $koList >> metagenomics.log
