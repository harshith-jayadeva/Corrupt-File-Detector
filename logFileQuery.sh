#!/bin/bash


if [ $# -ne 3 ]; then
	echo "Usage: ./logFileQuery.sh <target dir> <person> <month>" >2
	exit 1
fi

case $3 in  
	Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)
	 MON="$3"
	;;

	*)
	 echo "Invalid month"
	 exit 1
	;;
esac

NAME="$2"	
mkdir -p queryResults     

LOGFILES=$(grep -R -l -E '[012][0-9]/20[0-9][0-9]' "$1")


for FILE in $LOGFILES; do
	
	
	LENGTH=$(wc -l < "$FILE")
	COUNTER=1
	while [ $COUNTER -le $LENGTH ]; do
		LINE=$(head -n "$COUNTER" "$FILE" | tail -n 1)
	
		((COUNTER++))
		USERNAME=$(echo "$LINE" | awk '{print $3}')
		MONTH=$(echo "$LINE" | awk -F'/' '{print $1}' | awk -F'[' '{print $2}')
		YEAR=$(echo "$LINE" | awk -F'/' '{print $3}' | cut -d':' -f1)

		if [ "$NAME" = "$USERNAME" ] && [ "$MONTH" = "$3" ]; then
			echo $LINE >> "queryResults/${USERNAME}_${MONTH}_${YEAR}.log"
		fi	
	done	
	
done
				
