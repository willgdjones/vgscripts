#!/usr/local/bin/bash
 
prefix=$1 
read_number=$2
debug=$3

#Choose read_number of reads at random.

if [[ $debug == "0" ]];
then zcat $prefix/${prefix}all.fastq.gz | bioawk '{printf("%s%s",$0,(NR%4==0)?"\n":"\~")}' | shuf | tr '~' '\n' | head -$((read_number*4)) > $prefix/${prefix}.${read_number}rand.fastq;
fi

if [[ $debug == "1" ]];
then zcat $prefix/${prefix}all.fastq.gz | head -10000 | bioawk '{printf("%s%s",$0,(NR%4==0)?"\n":"\~")}' | shuf | tr '~' '\n' | head -$((read_number*4)) > $prefix/${prefix}.${read_number}rand.fastq 
fi

#Generate new indexes
bwa index /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/reference/SGD_2010.fasta

~/scripts/index.sh



#Align with BWA
bwa mem ~/WillJonesYeastVariationGraphs/data/reference/SGD_2010.fasta $prefix/${prefix}.${read_number}rand.fastq > $prefix/${prefix}.${read_number}rand.sam

samtools view $prefix/${prefix}.${read_number}rand.sam | cut -f10,2 | bioawk -c sam '{if ($1 == 16) print revcomp($2); else print $2 }' > $prefix/${prefix}.${read_number}rand.sam.seq

samtools view $prefix/${prefix}.${read_number}rand.sam | grep -o 'AS:i:[0-9]*' | grep -o '[0-9]*' > $prefix/${prefix}.${read_number}rand.sam.scores

paste $prefix/${prefix}.${read_number}rand.sam.seq $prefix/${prefix}.${read_number}rand.sam.scores | sort -k1 > $prefix/${prefix}.${read_number}rand.sam.scoredseqs

#Align with VG to a variation graph INCLUDING variation.
vg map -f $prefix/${prefix}.${read_number}rand.fastq -x ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100.xg -g ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p4.gcsa > $prefix/${prefix}.${read_number}rand.gam

vg view -a $prefix/${prefix}.${read_number}rand.gam | jq -r '[.sequence, .score] | @csv' | sed 's/\"//g' | tr ',' '\t' | sort -k1 > $prefix/${prefix}.${read_number}rand.gam.scoredseqs

#Align with VG to a variation graph EXLUDING variation

vg map -f $prefix/${prefix}.${read_number}rand.fastq -x ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraphreference-m100.xg -g ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraphreference-m100.gcsa > $prefix/${prefix}.${read_number}rand.control.gam

vg view -a $prefix/${prefix}.${read_number}rand.control.gam | jq -r '[.sequence, .score] | @csv' | sed 's/\"//g' | tr ',' '\t' | sort -k1 > $prefix/${prefix}.${read_number}rand.control.gam.scoredseqs


#Create comparison table INCLUDING variation
join -j 1 $prefix/${prefix}.${read_number}rand.sam.scoredseqs $prefix/${prefix}.${read_number}rand.gam.scoredseqs > $prefix/${prefix}.${read_number}rand.samgamscores

#Filter for only unique rows
uniq $prefix/${prefix}.${read_number}rand.samgamscores > $prefix/${prefix}.${read_number}rand.samgamscores.uniq

#Create comparison table EXCLUDING variation
join -j 1 $prefix/${prefix}.${read_number}rand.sam.scoredseqs $prefix/${prefix}.${read_number}rand.control.gam.scoredseqs > $prefix/${prefix}.${read_number}rand.control.samgamscores

#Filter for only unique rows
uniq $prefix/${prefix}.${read_number}rand.control.samgamscores > $prefix/${prefix}.${read_number}rand.control.samgamscores.uniq


