#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail -o posix

HOST=`hostname`
START=`date +"%d-%m-%Y.%Hh%Mm%Ss"`

cd $SCRATCH

cp /home/users/msserpa/microbenchmarks/mixed/mixed .

OUTPUT=$HOST.$START.csv

echo output file: $OUTPUT

echo "core,workload,appA,appB,value" > $OUTPUT

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
	echo "shared,FF,Fibonacci,Fibonacci,$F" >> $OUTPUT
	# echo "shared,FF,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed f,f 60 2> tmp
	
	F=`sed -n 4p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "private,FF,Fibonacci,Fibonacci,$F" >> $OUTPUT
	# echo "private,FF,loops,$LOOP" >> $OUTPUT
done

#FH
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,f 60 2> tmp
	
	H=`sed -n 1p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "shared,FH,Harmonic,Fibonacci,$H" >> $OUTPUT
	echo "shared,FH,Fibonacci,Harmonic,$F" >> $OUTPUT
	# echo "shared,FH,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,f 60 2> tmp
	
	H=`sed -n 1p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "private,FH,Harmonic,Fibonacci,$H" >> $OUTPUT
	echo "private,FH,Fibonacci,Harmonic,$F" >> $OUTPUT
	# echo "private,FH,loops,$LOOP" >> $OUTPUT
done

#FP
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,f 60 2> tmp
	
	P=`sed -n 2p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "shared,FP,Pointer,Fibonacci,$P" >> $OUTPUT
	echo "shared,FP,Fibonacci,Pointer,$F" >> $OUTPUT
	# echo "shared,FP,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,f 60 2> tmp
	
	P=`sed -n 2p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "private,FP,Pointer,Fibonacci,$P" >> $OUTPUT
	echo "private,FP,Fibonacci,Pointer,$F" >> $OUTPUT
	# echo "private,FP,loops,$LOOP" >> $OUTPUT
done

#FV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed v,f 60 2> tmp
	
	V=`sed -n 3p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "shared,FV,Vsum,Fibonacci,$V" >> $OUTPUT
	echo "shared,FV,Fibonacci,Vsum,$F" >> $OUTPUT
	# echo "shared,FV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed v,f 60 2> tmp
	
	V=`sed -n 3p tmp`
	F=`sed -n 4p tmp`
	LOOP=`sed -n 5p tmp`
	echo "private,FV,Vsum,Fibonacci,$V" >> $OUTPUT
	echo "private,FV,Fibonacci,Vsum,$F" >> $OUTPUT
	# echo "private,FV,loops,$LOOP" >> $OUTPUT
done

#H_

#HH
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
	H=`sed -n 1p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "shared,HH,Harmonic,Harmonic,$H" >> $OUTPUT
	# echo "shared,HH,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
	H=`sed -n 1p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "private,HH,Harmonic,Harmonic,$H" >> $OUTPUT
	# echo "private,HH,loops,$LOOP" >> $OUTPUT
done

#HP 
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
	H=`sed -n 1p tmp`
	P=`sed -n 2p tmp`
	LOOP=`sed -n 5p tmp`
	echo "shared,HP,Harmonic,Pointer,$H" >> $OUTPUT
	echo "shared,HP,Pointer,Harmonic,$P" >> $OUTPUT
	# echo "shared,HP,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,p 60 2> tmp
	
	H=`sed -n 1p tmp`
	P=`sed -n 2p tmp`
	LOOP=`sed -n 5p tmp`
	echo "private,HP,Harmonic,Pointer,$H" >> $OUTPUT
	echo "private,HP,Pointer,Harmonic,$P" >> $OUTPUT
	# echo "private,HP,loops,$LOOP" >> $OUTPUT
done

#HV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed h,v 60 2> tmp
	
	H=`sed -n 1p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "shared,HV,Harmonic,Vsum,$H" >> $OUTPUT
	echo "shared,HV,Vsum,Harmonic,$V" >> $OUTPUT
	# echo "shared,HV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed h,v 60 2> tmp
	
	H=`sed -n 1p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "private,HV,Harmonic,Vsum,$H" >> $OUTPUT
	echo "private,HV,Vsum,Harmonic,$V" >> $OUTPUT
	# echo "private,HV,loops,$LOOP" >> $OUTPUT
done

#P_

#PP
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "shared,PP,Pointer,Pointer,$P" >> $OUTPUT
	# echo "shared,PP,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "private,PP,Pointer,Pointer,$P" >> $OUTPUT
	# echo "private,PP,loops,$LOOP" >> $OUTPUT
done

#PV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "shared,PV,Pointer,Vsum,$P" >> $OUTPUT
	echo "shared,PV,Vsum,Pointer,$V" >> $OUTPUT
	# echo "shared,PV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	P=`sed -n 2p tmp`
	V=`sed -n 3p tmp`
	LOOP=`sed -n 5p tmp`
	echo "private,PV,Pointer,Vsum,$P" >> $OUTPUT
	echo "private,PV,Vsum,Pointer,$V" >> $OUTPUT
	# echo "private,PV,loops,$LOOP" >> $OUTPUT
done

#V_

#VV
export GOMP_CPU_AFFINITY=$aff_share
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	V=`sed -n 3p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "shared,VV,Vsum,Vsum,$V" >> $OUTPUT
	# echo "shared,VV,loops,$LOOP" >> $OUTPUT
done

export GOMP_CPU_AFFINITY=$aff
for step in `seq 1 10`; do
	./mixed p,v 60 2> tmp
	
	V=`sed -n 3p tmp | awk {'print $1 / 2'}`
	LOOP=`sed -n 5p tmp`
	echo "private,VV,Vsum,Vsum,$V" >> $OUTPUT
	# echo "private,VV,loops,$LOOP" >> $OUTPUT
done

cp $OUTPUT /home/users/msserpa/microbenchmarks/mixed/
