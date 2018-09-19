#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail -o posix

HOST=`hostname`
START=`date +"%d-%m-%Y.%Hh%Mm%Ss"`

OUTPUT=$HOST.$START.csv

echo output file: $OUTPUT

echo "core,workload,metric,value" > $OUTPUT

unset -v KMP_AFFINITY
unset -v GOMP_CPU_AFFINITY
unset -v OMP_NUM_THREADS
unset -v OMP_SCHEDULE

ncores=`cat /proc/cpuinfo | grep processor | wc -l`
lastcore=$(($ncores - 1))

export OMP_NUM_THREADS=2

for core in `seq 0 $lastcore`; do
	export GOMP_CPU_AFFINITY=0,$core
	for step in `seq 1 5`; do
		./mixed h 5 2> tmp
		LOOP=`sed -n 1p tmp`
		echo "$core,harmonic,loops,$LOOP" >> $OUTPUT
	done
done

for core in `seq 0 $lastcore`; do
	export GOMP_CPU_AFFINITY=0,$core
	for step in `seq 1 5`; do
		./mixed p 5 2> tmp
		LOOP=`sed -n 2p tmp`
		echo "$core,pointerChasing,loops,$LOOP" >> $OUTPUT
	done
done


for core in `seq 0 $lastcore`; do
	export GOMP_CPU_AFFINITY=0,$core
	for step in `seq 1 5`; do
		./mixed v 5 2> tmp
		LOOP=`sed -n 3p tmp`
		echo "$core,vsum,loops,$LOOP" >> $OUTPUT
	done
done


for core in `seq 0 $lastcore`; do
	export GOMP_CPU_AFFINITY=0,$core
	for step in `seq 1 5`; do
		./mixed f 5 2> tmp
		LOOP=`sed -n 4p tmp`
		echo "$core,fibonacciIt,loops,$LOOP" >> $OUTPUT
	done
done
