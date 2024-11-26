#!/usr/bin/bash

echo "--------------------- METAPIPELINE ---------------------------------------"
echo "                       FUNCTIONAL ANNOTATION DATABASES                                 "
echo "----------------------------------------------------------------------------------"

#Eggnog database
mkdir eggnogDB
download_eggnog_data.py -P --data_dir eggnogDB

#Kofam Database

mkdir kofamDB
cd kofamDB
wget ftp://ftp.genome.jp/pub/db/kofam/ko_list.gz		# download the ko list 
wget ftp://ftp.genome.jp/pub/db/kofam/profiles.tar.gz 		# download the hmm profiles
wget ftp://ftp.genome.jp/pub/tools/kofamscan/kofamscan.tar.gz	# download kofamscan tool
wget ftp://ftp.genome.jp/pub/tools/kofamscan/README.md		# download README

gunzip ko_list.gz
tar xf profiles.tar.gz
tar xf kofamscan.tar.gz

cd ..