#/bin/bash -vl
#PBS -l nodes=1:ppn=20,walltime=72:00:00 


function headless_ilastik {
name=${1##*\/}
cd $1
ls *.tif -l -m1 | xargs -n1 -I{} echo $PWD'/'{} > $'/hpcdata/sms/GlomerularIdentification/INPUT_FILES/'$name'.list'

run_ilastik.sh --headless \
	--project='/hpcdata/sms/GlomerularIdentification/QSUB_BASE/GlomIDDec2017.ilp' \
	--export_source="Simple Segmentation" \
	--output_format=tiff \
	--output_filename_format={dataset_dir}/{nickname}"_SimpleSegmentation.tiff" $( cat $'/hpcdata/sms/GlomerularIdentification/INPUT_FILES/'$name'.list' )
}
export -f headless_ilastik
module load ilastik

ihome='/hpcdata/sms/GlomerularIdentification/INPUT_FILES'
INPUT=$ihome'/input_dir695.list'

cnt=0
START=$(date +%s.$N)

#keep track of mem usage in separate shell; runs forever with special variable :
#while :; do top -b -n1 | awk 'NR==8' >> ~/$$_mem.log; sleep 30 done
echo $( cat $INPUT )

# provide a list with input dirs in home directory
if [ -f $INPUT ]; then
	read_file=$(<$INPUT);
	read_file=${read_file/$'\n')/ };
	read -a inparr <<< $read_file;
	echo ${#inparr[@]}
fi

for inp in ${inparr[@]}; do {
	cnt=$(( $cnt + $(ls -l $inp'/'*.tif | wc -l) ))
	headless_ilastik $inp
} 
done


END=$(date +%s.$N)
DIFF=$( echo "scale=1; $(echo "$END - $START" | bc)/3600" | bc )
echo "Summary: "$cnt" Images were processed in "$DIFF"h"

#878 images in 4.7 h segmented with ~38GB RAM and ~46 threads
