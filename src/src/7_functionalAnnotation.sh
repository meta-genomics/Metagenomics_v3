#!/usr/bin/bash

echo "--------------------- METAPIPELINE [PASO 10]---------------------------------------"
echo "                       FUNCTIONAL ANNOTATION                                    "
echo "----------------------------------------------------------------------------------"

threads=$1
prefix=$2
eggnogDB=$3
profile=$4
koList=$5

echo 'Test1'
for d in results/assemblies/$prefix*;
    do
    sample=${d:19}
	echo $sample 'Functional annotation Start'
	start_time=$(date +"%T")
	echo $start_time
	
	for a in results/geneAnnotation/$sample/*;
		do
		base=$(echo "$a"|cut -d '/' -f 4)
		echo $base 'Start'
		
		mkdir results/functionalAnnotation/eggNOG/$sample/$base
		mkdir results/functionalAnnotation/kofam/$sample/$base
		
		echo "emapper.py --cpu $threads --override -i results/geneAnnotation/$sample/$base/${base}.faa --itype proteins --data_dir $eggnogDB -m diamond --report_no_hits --pfam_realign none --output $base --output_dir results/functionalAnnotation/eggNOG/$sample/$base"
		
		emapper.py \
		--cpu $threads \
		--override \
		-i results/geneAnnotation/$sample/$base/${base}.faa \
		--itype proteins \
		--data_dir $eggnogDB \
		-m diamond \
		--report_no_hits \
		--pfam_realign none \
		--output $base \
		--output_dir results/functionalAnnotation/eggNOG/$sample/$base
		
		echo $base 'Functional diamond annotation done'
		
		exec_annotation \
		-f mapper \
		--cpu $threads \
		-o results/functionalAnnotation/kofam/$sample/$base/kofam_${base}.txt \
		-p $profile \
		-k $koList \
		--create-alignment \
		results/geneAnnotation/$sample/$base/${base}.faa
		
		echo $base 'Functional kofam annotation done'
		
		done
	done
end_time=$(date +"%T")
echo $end_time
cd ..