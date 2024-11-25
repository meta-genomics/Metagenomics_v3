#!/usr/bin/bash

echo "--------------------- METAPIPELINE ---------------------------------------"
echo "                       Taxonomic AssignmentMAGs                                   "
echo "----------------------------------------------------------------------------------"

threads=$1
prefix=$2

cd results/
for d in assemblies/$prefix*;
    do
    base=${d:11}

    #Assign taxonomy labels to each bin
    #Check -n parameter for next analysis
    phylophlan_metagenomic \
    -i assemblies/${base}/maxbin/ \
    -o taxonomy/phylophlan/$base/$base\_metagenomic \
    --nproc $threads \
    -n 1 \
    -d SGB.Jul20 \
    --database_folder ../phylophlanDB/ \
    -e .fasta \
    --verbose 2>&1 | tee taxonomy/phylophlan/$base/phylophlan_metagenomic.log

    # echo $base 'Taxonomy Assignment MAGs Done'
    done

#Heatmap
#This step allows you to visualize the top 20 separate by sample

cat taxonomy/phylophlan/$prefix*/*\_metagenomic.tsv > taxonomy/$prefix\_phylophlanReport.tsv

phylophlan_draw_metagenomic \
-i taxonomy/$prefix\_phylophlanReport.tsv \
-o taxonomy/phylophlan/$prefix\_output_heatmap \
--map taxonomy/$prefix\Meta_Bins.tsv \
--dpi 1500 \
--top 20 \
--verbose 2>&1

echo 'heatmaps MAGs Done'

cd ..