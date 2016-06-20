bwa index ~/WillJonesYeastVariationGraphs/data/reference/SGD_2010.fasta

vg index -x /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100.xg /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100.vg
vg mod -pl 16 -e 3 /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p1.vg > /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p2.vg
vg mod -S -l 32 /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p2.vg > /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p3.vg
vg kmers -gB -k 16 -H 1000000000 -T 1000000001 /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p3.vg > /nfs/users/nfs_w/wj2/WillJonesYeastVariationGraphs/data/graphs/yeastgraph-m100-p4.graph
