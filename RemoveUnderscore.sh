#/bin/bash -vl
#PBS -l nodes=1:ppn=2,walltime=5:00:00
#PBS -q batch


cd /hpcdata/sms/GlomerularIdentification/ImageData/LDHBTrichrome/Images/Tifs

ls |while read file; do mv $file "$(echo "$file"|sed -e 's/_/s/g')";done
