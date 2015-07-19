LOCATION="/etc/nginx/locations"
FILE="$LOCATION/.includeall"

printf "### $(date)\n\n" > $FILE 

for NAME in $(ls $LOCATION);
do
	printf "### $NAME\ninclude $LOCATION/$NAME;\n\n" >> $FILE
done;
