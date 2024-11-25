#!/usr/bin/bash

echo "--------------------- METAPIPELINE [PASO 3]---------------------------------------"
echo "                       TAXONOMIC ASSIGNMENT HOST REMOVED                                   "
echo "----------------------------------------------------------------------------------"

threads=$1
extension=$2
krakenDB=$3


# Taxonomic assignment ---------------------------------------------------
cd results/
for file in ../raw-reads/*_1.$extension;
    do
    base=$(basename ${file} _1.$extension)
	folder="${base%%_*}"
	echo "taxonomic assignment sample $base"
	R1=${folder}_host_removed_R1.fastq.gz
	#echo $R1
    R2=${folder}_host_removed_R2.fastq.gz
	#echo $R2


	wdir=taxonomy/kraken/${folder}/hostRemoved
		
	if [ -d "$wdir" ]; then 
		echo IMPORTANT:
		echo There is a previous run for sample: ${folder}
		echo The directory ${wdir} will be deleted 
		rm -r $wdir
	fi
	mkdir $wdir
	echo New directory ${wdir} created for sample ${folder}

	kraken2 --db $krakenDB \
		--threads $threads \
		--gzip-compressed \
		--output ${wdir}/${folder}.kraken.out \
		--report ${wdir}/${folder}.kraken.report \
		--paired host_removed/$folder/$R1 host_removed/$folder/$R2 

	done
	echo "---------------------- METAPIPELINE [PASO 4]---------------------------------------"
	echo "                       PARSING KRAKEN'S OUTPUT                                     "
	echo "-----------------------------------------------------------------------------------"
# Create json file for R analysis ------------------------------------
#	 kraken-biom parses the .report files.
# 	 The option --min P can be used to keep assignments that have 
#	 at least phylum taxa, but this can also be filtered during
#	 the R analysis

kraken-biom taxonomy/kraken/*/hostRemoved/*.report \
	-o taxonomy/taxonomy_kraken.json \
	--fmt json  
cd ..