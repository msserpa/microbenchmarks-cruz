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


#F_

#FF
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed f,f 60 2> tmp
	
	F=`sed -n 4p tmp | awk {'print $1 / 2'}` 
	LOOP=`sed -n 5p tmp`
	echo "share,FF,F,$F" >> $OUTPUT
	echo "share,FF,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed f,f 60 2> tmp
	
	F=`sed -n 4p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "no,FF,F,$F" >> $OUTPUT
	echo "no,FF,loops,$LOOP" >> $OUTPUT
done

#FH
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,f 60 2> tmp
	
	H=`sed -n 1p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,FH,H,$H" >> $OUTPUT
	echo "share,FH,F,$F" >> $OUTPUT
	echo "share,FH,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,f 60 2> tmp
	
	H=`sed -n 1p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,FH,H,$H" >> $OUTPUT
	echo "no,FH,F,$F" >> $OUTPUT
	echo "no,FH,loops,$LOOP" >> $OUTPUT
done

#FP
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,f 60 2> tmp
	
	P=`sed -n 2p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,FP,P,$P" >> $OUTPUT
	echo "share,FP,F,$F" >> $OUTPUT
	echo "share,FP,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,f 60 2> tmp
	
	P=`sed -n 2p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,FP,P,$P" >> $OUTPUT
	echo "no,FP,F,$F" >> $OUTPUT
	echo "no,FP,loops,$LOOP" >> $OUTPUT
done

#FV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed v,f 60 2> tmp
	
	V=`sed -n 3p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,FV,V,$V" >> $OUTPUT
	echo "share,FV,F,$F" >> $OUTPUT
	echo "share,FV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed v,f 60 2> tmp
	
	V=`sed -n 3p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,FV,V,$V" >> $OUTPUT
	echo "no,FV,F,$F" >> $OUTPUT
	echo "no,FV,loops,$LOOP" >> $OUTPUT
done

#H_

#HH
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
	H=`sed -n 1p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "share,HH,H,$H" >> $OUTPUT
	echo "share,HH,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
	H=`sed -n 1p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "no,HH,H,$H" >> $OUTPUT
	echo "no,HH,loops,$LOOP" >> $OUTPUT
done

#HP 
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
	H=`sed -n 1p tmp`
	P=`sed -n 2p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,HP,H,$H" >> $OUTPUT
	echo "share,HP,P,$P" >> $OUTPUT
	echo "share,HP,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
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
	./mixed h,v 60 2> tmp
	
	H=`sed -n 1p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,HV,H,$H" >> $OUTPUT
	echo "share,HV,V,$V" >> $OUTPUT
	echo "share,HV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,v 60 2> tmp
	
	H=`sed -n 1p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,HV,H,$H" >> $OUTPUT
	echo "no,HV,V,$V" >> $OUTPUT
	echo "no,HV,loops,$LOOP" >> $OUTPUT
done

#P_

#PP
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "share,PP,P,$P" >> $OUTPUT
	echo "share,PP,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "no,PP,P,$P" >> $OUTPUT
	echo "no,PP,loops,$LOOP" >> $OUTPUT
done

#PV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "share,PV,P,$P" >> $OUTPUT
	echo "share,PV,V,$V" >> $OUTPUT
	echo "share,PV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "no,PV,P,$P" >> $OUTPUT
	echo "no,PV,V,$V" >> $OUTPUT
	echo "no,PV,loops,$LOOP" >> $OUTPUT
done

#V_

#VV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	V=`sed -n 3p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "share,VV,V,$V" >> $OUTPUT
	echo "share,VV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	V=`sed -n 3p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "no,VV,V,$V" >> $OUTPUT
	echo "no,VV,loops,$LOOP" >> $OUTPUT
done
