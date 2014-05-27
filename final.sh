#####################################################################
#                                                                   #
# This is final script to be initiated after completion of work     #
#                                                                   #
#####################################################################

###################### Wrapping up everything ##################################
echo "Wrapping up everything now" >> log/main.log;
dir=`ls | grep v | head -n 1`;
echo $dir;
if [ -z $dir ]; then
	echo "No more directory to delete finishing everything " >> log/main.log;
	else
		while [ ! -z $dir ]
			do
				cd $dir;
				vagrant destroy -f >> ../log/main.log &
				pid=$!;
				wait $pid;
				cd ..;
				rm -r $dir;
				echo "Removed directory $dir moving to next" >> log/main.log;
				dir=`ls | grep v | head -n 1`;
			done
fi

rm newa*;
