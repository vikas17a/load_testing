###############################################################################
######    This is a parsing script to parse the access.log file         #######     
###############################################################################
if [ -z $1 ]; then
	echo "ERROR : Parameter not found";
fi

while read line
do
	echo $line | jq '.req';
done < $1;
