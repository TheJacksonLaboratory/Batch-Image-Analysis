#/bin/bash -vl
#PBS -l nodes=1:ppn=2,walltime=5:00:00
#PBS -q batch

for filename in *.tif 
do 

	echo ${filename} | sed 's,_,s,g'
done
