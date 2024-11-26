#!/usr/bin/bash
 #####################################################################
# Usage:                                                
#       1. Correr este script indicando el número de threads. E.g.:
#                       phylophlanDB 16
#####################################################################

threads=$1
echo "-------------------------- METAPIPELINE -----------------------------------------"
echo "                          Phylophlan DB construction                                "
echo "---------------------------------------------------------------------------------"

mkdir phylophlanDB

wget -P phylophlanDB/ http://cmprod1.cibio.unitn.it/databases/PhyloPhlAn/phylophlan.tar 
wget -P phylophlanDB/ http://cmprod1.cibio.unitn.it/databases/PhyloPhlAn/phylophlan.md5

diff <(md5sum phylophlanDB/phylophlan.tar) phylophlanDB/phylophlan.md5

tar -xf phylophlanDB/phylophlan.tar
bunzip2 -k phylophlanDB/phylophlan/phylophlan.bz2

diamond makedb --threads $threads --in phylophlanDB/phylophlan/phylophlan.faa --db phylophlanDB/phylophlan/phylophlan