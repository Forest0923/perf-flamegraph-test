#!/bin/bash

ioengine=(
	libaio
	sync
	mmap
)

fio_conf=configs
img=images

if [ ! -d $img ]; then
	mkdir $img
fi

for i in "${ioengine[@]}"; do
	perf record -o /tmp/perf_$i.data -g fio $fio_conf/seq_read_$i.ini
done

# export flamegraph
for i in "${ioengine[@]}"; do
	perf script -i /tmp/perf_$i.data | stackcollapse-perf.pl | flamegraph.pl > $img/perf_$i.svg
done
