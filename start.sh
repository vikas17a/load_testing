##################################################################
###                                                           ####
###     Starting the load test script                         ####   
###                                                           ####
##################################################################
######## Files Required to run this script are ###################
######## Command line parameter as a access file #################
######## Parser.sh to parse the access.log file ################## 
######## Peakhour.sh to find the peak hour #######################       
######## Spawn vagrant and work ##################################
##################################################################

if [ -z $1 ]; then
	echo "ERROR : Please use it as 'sh start.sh filename(accesslog)'";
	exit 1;
fi

date=`date`;
sh configure.sh;
if [ ! -d "log" ]; then
	echo "ERROR : Please restart the test";
	exit 1;
fi

cd log/;
touch main.log;
cd ..;

echo "@@@@@@@@@ Script initiated @@@@@@@@" >> log/main.log;
if [ ! -f "parse.sh" ]; then
	echo "ERROR : Please make sure you have all files" >> log/main.log;
	exit 1;
fi

####################### Splitting up files in parts ###########################
#size=`du -h $1 | cut -f1`;
#len_size=`expr length $size`;
#len_size=`expr $len_size \- 1`;
#extracted_size=`echo $size | cut -c 1-$len_size`;
#extracted_size=`expr $extracted_size \/ 3`;
#sub=`expr $extracted_size=`
#split --bytes=$extracted_size"M" $1 new;

no_line=`wc -l $1 | awk '{print $1}'`;
chunk=`expr $no_line \/ 3`;
split -l $chunk $1 new &
sleep 2;
echo "File divided into equal size chunk" >> log/main.log;
#################################### Moving file into the master folder #####################################

echo "Copying chunk 1 to master folder" >> log/main.log;
cp newaa ../data/;
sleep 5;
echo "Copying chunk 2 to master folder " >> log/main.log;
cp newab ../data/;
sleep 5;
echo "Copying chunk 3 to master folder " >> log/main.log;
cp newac ../data/;
sleep 5;
echo "All chunks moved to master folder " >> log/main.log;


echo "~~~~~~~~~~~~~~~~~Spinning up VM's~~~~~~~~~~~~~~~~~~~" >> log/main.log; 
#################### VM spin up ##############################################
count=3;
while [ $count -ne 0 ]
do
	echo "Creating directory v$count" >> log/main.log;
	mkdir v$count;
	echo "Copying VagrantFile to v$count" >> log/main.log;
	cp ../Vagrantfile$count v$count/VagrantFile;
	echo "VagrantFile copied to v$count" >> log/main.log;
	echo "Copying package.box to v$count" >> log/main.log;
	cp ../package.box v$count/;
	echo "Copied package.box to v$count" >> log/main.log;
	sleep 10;
	cd v$count;
	echo "Adding box $count" >> ../log/main.log;
	vagrant box add package.box --name box$count.box >> ../log/main.log &
	pid=$!;
	wait $pid;
	echo "Box $count added successfully " >> ../log/main.log;
	vagrant up >> ../log/main.log &
	pid=$!;
	wait $pid;
	echo "Virtual Machine $count is up" >> ../log/main.log;
	cd ..;
	count=`expr $count - 1`;
done;
######################  Work from 3 VM's ################################

echo "Processing the work of each VM" >> log/main.log;
dir_a=v1;
dir_b=v2;
dir_c=v3;
file_a=newaa;
file_b=newab;
file_c=newac;

echo "Moving parsing script to master folder" >> log/main.log;
cp parse.sh ../data/;

count=3;

while [ $count -ne 0 ]
do
	if [ $count -eq 3 ]; then
		cd $dir_c;
		echo "Starting VM $count parsing process" >> ../log/main.log;
		echo "cp /sync_folder/parse.sh .;" >> ../work$count.sh;
		echo "cp /sync_folder/$file_c .;" >> ../work$count.sh;
		echo "sh parse.sh $file_c >> v$count &" >> ../work$count.sh;
		echo "pid=\$!;" >> ../work$count.sh;
		echo "wait \$pid;" >> ../work$count.sh;
		echo "sudo cp v$count /sync_folder/;" >> ../work$count.sh;
		vagrant ssh  < ../work$count.sh >> /dev/null &
		pid_1=$!;
		cd ..;
	elif [ $count -eq 2 ]; then
		cd $dir_b;
		echo "Starting VM $count parsing process" >> ../log/main.log;
		echo "cp /sync_folder/parse.sh .;" >> ../work$count.sh;
		echo "cp /sync_folder/$file_b .;" >> ../work$count.sh;
		echo "sh parse.sh $file_b >> v$count &" >> ../work$count.sh;
		echo "pid=\$!;" >> ../work$count.sh;
		echo "wait \$pid;" >> ../work$count.sh;
		echo "sudo cp v$count /sync_folder/;" >> ../work$count.sh;
		vagrant ssh  < ../work$count.sh >> /dev/null &
		pid_2=$!;
		cd ..;
	elif [ $count -eq 1 ]; then
		cd $dir_a;
		echo "Starting VM $count parsing process" >> ../log/main.log;
		echo "cp /sync_folder/parse.sh .;" >> ../work$count.sh;
		echo "cp /sync_folder/$file_a .;" >> ../work$count.sh;
		echo "sh parse.sh $file_a >> v$count &" >> ../work$count.sh;
		echo "pid=\$!;" >> ../work$count.sh;
		echo "wait \$pid;" >> ../work$count.sh;
		echo "sudo cp v$count /sync_folder/;" >> ../work$count.sh;
		vagrant ssh  < ../work$count.sh >> /dev/null &
		pid_3=$!;
		cd ..;
	fi
	count=`expr $count \- 1`;
done

wait $pid_1 $pid_2 $pid_3;

echo "Finishing work of all VM's" >> log/main.log;

echo "Exiting successfully" >> log/main.log;

###################### Wrapping up everything ##################################
echo "Wrapping up everything now" >> log/main.log;
dir=`ls | grep v | head -n 1`;
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

date=`date +%s`;
cp log/main.log log/"$date".log;