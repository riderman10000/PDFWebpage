#!/bin/sh
echo "making directory"

#script to create directory for the following sujects
#just a test so can add no of years and semester 
years=2 							#total no of year
semester=2						#semester per year
subject=7							#sujects per year

matrix=( math1 programming drawing physics applied electrical null math2 drawing2 electronics chemistry thermo workshop vacant math3 OOP ckt material EDC digitallogic magnetics machine NM maths instrumenatation power microprocessor discrete)


for (( i = 0; i < ${years} ; i++ )); do
	for (( j = 0; j < ${semester}; j++ )); do
		for (( k = 0; k < ${subject}; k++ )); do
					var=14*${i}+7*${j}+${k}
					var1=$((semester*subject*i+subject*j+k))
					#echo ${var}
					#echo ${var1}
					echo "[*] Creating folder for : ${matrix[${var}]}"
					if [[ ${matrix[${var}]} == *"null"* ]]; then
						echo "[-] Skipping Null variable or classes."
					else
						mkdir -vp ./project/year$((i+1))/$(((i*2)+(j*1)+1))sem/${matrix[${var}]}
						chmod g+w ./project/year$((i+1))/$(((i*2)+(j*1)+1))sem/${matrix[${var}]}
						echo "[+] Folder for respective class created."
			fi
		done	
	done
done

# 0  1  2  3  4  5  6 
# 7  8  9 10 11 12 13
#14 15 16 17 18 19 20
#21 22 23 24 25 26 27
