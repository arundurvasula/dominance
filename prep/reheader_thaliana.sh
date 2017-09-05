#!/bin/bash
#$ -cwd
#$ -V
#$ -N reheader
#$ -l h_data=8G,time=4:00:00
#$ -M eplau
#$ -m bea

set -e
#set -u
#set -o

. /u/local/Modules/default/init/modules.sh
module load samtools

SAMPLES=(18510_AAGACGGA_C41F2ACXX_6_20140423B_20140423 18512_CGAACTTA_C41F2ACXX_6_20140423B_20140423 18514_TGAAGAGA_C41F2ACXX_6_20140423B_20140423 22002_GAATCTGA_C5E9DANXX_6_20140930B_20140930 22004_AAGAGATC_C5E9DANXX_6_20140930B_20140930 22006_GAGTTAGC_C5E9DANXX_6_20140930B_20140930 35513_GTGGCC_C8DE0ANXX_4_20160129B_20160129 35594_GCCAAT_C8DE0ANXX_5_20160129B_20160129 35599_GTTTCG_C8DE0ANXX_5_20160129B_20160129 35600_CGTACG_C8DE0ANXX_5_20160129B_20160129 35601_TGACCA_C8DE0ANXX_5_20160129B_20160129 35605_CAGATC_C8DE0ANXX_6_20160129B_20160129 35607_ACTGAT_C8DE0ANXX_6_20160129B_20160129 35608_CGATGT_C8DE0ANXX_6_20160129B_20160129 35610_GGCTAC_C8DE0ANXX_6_20160129B_20160129 35611_ATTCCT_C8DE0ANXX_6_20160129B_20160129 35615_TAGCTT_C8DE0ANXX_6_20160129B_20160129 35618_GCCAAT_C8DE0ANXX_7_20160129B_20160129 35619_AGTTCC_C8DE0ANXX_7_20160129B_20160129 35621_CGTACG_C8DE0ANXX_7_20160129B_20160129 35622_GTGAAA_C8DE0ANXX_7_20160129B_20160129 35623_CAGATC_C8DE0ANXX_7_20160129B_20160129 35625_GTCCGC_C8DE0ANXX_7_20160129B_20160129 37469_CAGATC_C89VWANXX_2_20160414B_20160414 37471_AGTCAA_C89VWANXX_2_20160414B_20160414)


for SAMPLE in ${SAMPLES[@]}
do

##file="data/aligned/35600_CGTACG_C8DE0ANXX_5_20160129B_20160129.cleanedaligned.markdup.indel.bam" # test case
file="data/aligned/${SAMPLE}.cleanedaligned.markdup.indel.bam"
samtools view -H $file > $file.header.sam
old_RG="`sed -n '9p' $file.header.sam`"

to_keep="`echo $old_RG | cut -f 1-6 -d ' '`"

sample=`basename $file | cut -f 1 -d "_"`
new_tag="SM:"$sample

out_line=$to_keep" "$new_tag
out_line2=`echo "$out_line" | tr ' ' $"\\t"`
sed -i "9s/.*/${out_line2}/" $file.header.sam # add -i later for in place


#cat $file.header.sam
samtools reheader ${file}.header.sam ${file} > ${file}.reheader.bam
samtools index ${file}.reheader.bam
done