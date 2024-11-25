#!/usr/bin/bash

echo "--------------------- METAPIPELINE [PASO 9]---------------------------------------"
echo "					   GENE ANNOTATION									"
echo "----------------------------------------------------------------------------------"

threads=$1
prefix=$2

cd results/
for a in assemblies/$prefix*;
	do
	sample=${a:11}
	echo $sample 'Gene annotation Start'
	start_time=$(date +"%T")
	echo $start_time
	
	for d in assemblies/$sample/maxbin/*.fasta;
		do
		base=$(echo "$d"|cut -d '/' -f 4)
		base=${base/.fasta/}
		echo $base 'Start'
		
		mkdir geneAnnotation/$sample/$base
		
	#Search annotation kingdom type for MAG
		anno=$(grep -w "${base}" taxonomy/MAGS/phylophlan/$sample/${sample}_metagenomic.tsv)
		
		if [[ -z "$anno" ]]
			then
				echo $base 'skipped'
				continue
			else
				anno=$(echo "$anno"|grep -o "k__.*|p"|cut -d '_' -f 3| cut -d '|' -f 1)
				echo $base 'With taxonomy' $anno
				prokka \
				--outdir geneAnnotation/$sample/$base \
				--kingdom $anno \
				--metagenome \
				--prefix $base \
				--compliant \
				--cpus $threads \
				--quiet \
				--force \
				$d
				echo $base 'finished'
		fi
		done
	end_time=$(date +"%T")
	echo $end_time
	echo $sample 'Gene annotation Done'
	done

cd ..
