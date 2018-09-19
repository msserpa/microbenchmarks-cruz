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

export OMP_NUM_THREADS=$ncores

aff_share=""
for core in `seq 0 $lastcore`; do
	aff_share+="$core,"
done
aff_share=${aff_share::-1}
echo $aff_share

aff=""
for core in `seq 0 $(($lastcore / 2))`; do
	aff+="$core,"
	aff+="$(($core + $(($ncores / 2)))),"
done
aff=${aff::-1}
echo $aff


#HP 
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,p 30 2> tmp
	
	H=`sed -n 1p tmp`
	P=`sed -n 2p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,HP,H,$H" >> $OUTPUT
	echo "share,HP,P,$P" >> $OUTPUT
	echo "share,HP,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,p 30 2> tmp
	
	H=`sed -n 1p tmp`
	P=`sed -n 2p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,HP,H,$H" >> $OUTPUT
	echo "no,HP,P,$P" >> $OUTPUT
	echo "no,HP,loops,$LOOP" >> $OUTPUT
done

#HV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,v 30 2> tmp
	
	H=`sed -n 1p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,HV,H,$H" >> $OUTPUT
	echo "share,HV,V,$V" >> $OUTPUT
	echo "share,HV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,v 30 2> tmp
	
	H=`sed -n 1p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,HV,H,$H" >> $OUTPUT
	echo "no,HV,V,$V" >> $OUTPUT
	echo "no,HV,loops,$LOOP" >> $OUTPUT
done

#HF
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,f 30 2> tmp
	
	H=`sed -n 1p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,HF,H,$H" >> $OUTPUT
	echo "share,HF,F,$F" >> $OUTPUT
	echo "share,HF,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,f 30 2> tmp
	
	H=`sed -n 1p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,HF,H,$H" >> $OUTPUT
	echo "no,HF,F,$F" >> $OUTPUT
	echo "no,HF,loops,$LOOP" >> $OUTPUT
done

#PV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,v 30 2> tmp
	
	P=`sed -n 2p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,PV,P,$P" >> $OUTPUT
	echo "share,PV,V,$V" >> $OUTPUT
	echo "share,PV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,v 30 2> tmp
	
	P=`sed -n 2p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,PV,P,$P" >> $OUTPUT
	echo "no,PV,V,$V" >> $OUTPUT
	echo "no,PV,loops,$LOOP" >> $OUTPUT
done

#PF
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,f 30 2> tmp
	
	P=`sed -n 2p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,PF,P,$P" >> $OUTPUT
	echo "share,PF,F,$F" >> $OUTPUT
	echo "share,PF,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,f 30 2> tmp
	
	P=`sed -n 2p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,PF,P,$P" >> $OUTPUT
	echo "no,PF,F,$F" >> $OUTPUT
	echo "no,PF,loops,$LOOP" >> $OUTPUT
done

#VF
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed v,f 30 2> tmp
	
	V=`sed -n 3p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,VF,V,$V" >> $OUTPUT
	echo "share,VF,F,$F" >> $OUTPUT
	echo "share,VF,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed v,f 30 2> tmp
	
	V=`sed -n 3p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,VF,V,$V" >> $OUTPUT
	echo "no,VF,F,$F" >> $OUTPUT
	echo "no,VF,loops,$LOOP" >> $OUTPUT
done
