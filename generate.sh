#!/usr/local/bin/bash

function bsubq {
        bsub -o ${2-:output.out} -e ${3-:progress.err} \
            -R"select[mem>16000] rusage[mem=16000]" \
            -q normal -m vr-4-1-[01-16] -T 16 $1
}

#When using a variation graph 
for f in $(ls | cat | grep 'NCYC'); do ~/scripts/compare.sh 10000${f} $f/10000${f}all.fastq ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100.xg ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p4.gcsa ~/WillJonesYeastVariationGraphs/data/reference/SGD_2010.fasta > $f/10000${f}allsamgamscores.txt; done;

#When just having a reference 
for f in $(ls | cat | grep 'NCYC'); do ~/scripts/compare.sh 10000${f}ref $f/10000${f}all.fastq ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraphreference-m100.xg ~/WillJonesYeastVariationGraphs/data/graphs/yeastgraphreference-m100.gcsa ~/WillJonesYeastVariationGraphs/data/reference/SGD_2010.fasta > $f/10000${f}refsamgamscores.txt; done;
