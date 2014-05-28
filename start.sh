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
echo "" > main.log;
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
mv newaa ../data/;
sleep 5;
echo "Copying chunk 2 to master folder " >> log/main.log;
mv newab ../data/;
sleep 5;
echo "Copying chunk 3 to master folder " >> log/main.log;
mv newac ../data/;
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

echo "Removing split files"  >> log/main.log;
rm ../data/new*;
echo "Finalizing work of all VM's" >> log/main.log;

################## Merging the individual file for the largevm processing ##################

cat ../data/v1 >> ../data/out;
cat ../data/v2 >> ../data/out;
cat ../data/v3 >> ../data/out;

rm ../data/v1;
rm ../data/v2;
rm ../data/v3;


echo "Exiting successfully" >> log/main.log;

###################### Wrapping up every worker vm ##################################
echo "Wrapping up every worker vm now" >> log/main.log;
dir=`ls | grep v | head -n 1`;
if [ -z $dir ]; then
	echo "No more directory to delete finalizing everything " >> log/main.log;
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
############### Removal of boxes from vagrant service ############################### 
echo "Removing vagrant boxes" >> log/main.log;
count=3;

while [ $count -ne 0 ]
do
	echo "Removing vagrant box$count.box" >> log/main.log;
	vagrant box remove box$count.box >> log/main.log;
	sleep 5;
	count=`expr $count \- 1`;
done

############# Boxes removed ##########################################################

######################## Spawning large vm ###########################################
echo "Spawning box with large ram to process the merge file " >> log/main.log;


#### Making directory ##############
echo "Creating directory for the large VM" >> log/main.log;
mkdir v1;
echo "Directory created" >> log/main.log;


#### Copying vagrantfile ###########
echo "Copying VagrantFile for large VM" >> log/main.log;
cp ../VagrantFile v1/;
sleep 2;
echo "Vagrant file Copied" >> log/main.log;

#### Copying package.box ##########
echo "Copying package box to large machine" >> log/main.log;
cp ../package.box v1/;
echo "Copied package box" >> log/main.log;

echo "Entering into the directory of large VM" >> log/main.log;
cd v1;
echo "Entered into the directory of large VM " >> ../log/main.log;

###### Adding the box ############# 
echo "Adding box to the vagrant service for large VM" >> ../log/main.log;
vagrant box add package.box --name box1.box >> ../log/main.log &
pid=$!;
wait $pid;
echo "Box added for large vm" >> ../log/main.log;

##### Large VM UP ##############
echo "Large VM going up be safe !!!! " >> ../log/main.log;
vagrant up >> ../log/main.log &
pid=$!;
wait $pid;
echo "Large VM is up" >> ../log/main.log;

cd ..;
echo "Out of Large Vm directory" >> log/main.log;


####### Work for largevm ##############
echo "Creating worker file for largevm " >> log/main.log;
echo "cp /sync_folder/out ." >> work_lm.sh;
echo "awk '{print \$2}' out | sort | uniq -c | sort -nr | head -n 30 > final_result;" >> work_lm.sh;
echo "sudo cp final_result /sync_folder/" >> work_lm.sh;
echo "Worker file created for largevm " >> log/main.log;

echo "Processing up large vm with worker file" >> log/main.log;
echo "Entered into the directory of largevm" >> log/main.log;
cd v1;
echo "Starting ssh connection with largevm" >> ../log/main.log;
############# SSH and work ############
vagrant ssh < ../work_lm.sh &
pid=$!;
wait $pid;
echo "Processing completed by largevm" >> ../log/main.log;
cd ..;
echo "Out of the directory of largevm" >> log/main.log;


echo "Entering into the largevm directory" >> log/main.log; 
cd v1;
echo "Destroying the largevm" >> ../log/main.log;

############# Destroying Vagrant ###############
vagrant destroy -f >> ../log/main.log;
sleep 10;
echo "Destroyed largevm :(" >> ../log/main.log;
cd ..;
echo "Out of directory of largevm" >> log/main.log;

########## Finding peak hour ####################

echo "Calculating peak frequency from log file" >> log/main.log;
hour=`cat $1 | cut -d[ -f2 | cut -d] -f1 | awk -F: '{print $2":00"}' | sort -n | uniq -c | sort -r | head -n 1 | awk '{print $1}'`;
#sleep 10;
echo "Total connection in peak hour are $hour" >> log/main.log;
min=`expr $hour \/ 60`;
echo "Total connection on avg. minute from peak hour are $min" >> log/main.log;
act_min=`cat $1 | cut -d[ -f2 | cut -d] -f1 | awk -F: '{print $2":"$3}' | sort -nk1 -nk2 | uniq -c | awk '{ if ($1 > 10) print $0}' | sort -r | head -n 1 | awk '{print $1}'`;
sec=`expr $min \/ 60`;
echo "Total connection on avg. second from peak hour are $sec"  >> log/main.log;
act_sec=`expr $act_min \/ 60`;
act_sec=`expr $act_sec \ + 1`;
sec=`echo $act_sec`;
echo "Round of total connection on avg. second from peak hour are $sec " >> log/main.log;

########## Creating worker file for the VM to perform load #################

if [ -f "load.sh" ]; then
	rm load.sh;
	touch load.sh;
else
	touch load.sh;
fi

count=1;

while read line
do
	total_req=`echo $line | awk '{print $1}'`;
	url=`echo $line | awk '{print $2}'`;
	echo "Calculated total number of request for $url are $total_req" >> log/main.log;
	#num_con=`expr $total_req \* 3`;
	echo "httperf --server=\"www.localsmokehk.com\" --uri=\"$url\" --rate=\"$sec\" --num-con=\"$total_req\" --num-call=\"1\" > result &" >> load.sh;
	echo "pid=\$!;" >> load.sh;
	echo "wait \$pid;" >> load.sh;
	echo "cp result /sync_folder/res$count;" >> load.sh;
	count=`expr $count \+ 1`;  
done < ../data/final_result;

#######################Starting sending request####################################

echo "Entering into largevm directory" >> log/main.log;
cd v1/;
echo "Bringing largevm up" >> ../log/main.log;
vagrant up >> ../log/main.log &
pid=$!;
wait $pid;
echo "Lagevm is up" >> ../log/main.log;

echo "Starting load largevm" >> ../log/main.log;
vagrant ssh < ../load.sh &
pid=$!;
wait $pid;
echo "Load test completed" >> ../log/main.log;

echo "Destroying the largevm" >> ../log/main.log;

############# Destroying Vagrant ###############
vagrant destroy -f >> ../log/main.log;
sleep 10;
echo "Destroyed largevm :(" >> ../log/main.log;
cd ..;


########### Removing all files #########################
echo "Removing the largevm directory" >> log/main.log;
rm -r v1/;
echo "Removed largevm directory"  >> log/main.log;

echo "Removing worker files" >> log/main.log;
rm work*;
echo "Removed worker file" >> log/main.log;
rm load.sh;
echo "Removed load file from data/ " >> log/main.log;
rm ../data/out;
echo "Removed out file from data/" >> log/main.log;
rm ../data/parse.sh;
echo "Removed parse.sh from data/" >> log/main.log;

echo "Destroying box for largevm" >> log/main.log;
vagrant box remove box1.box >> log/main.log;
sleep 3;

########### Saving logs thank you #############
date=`date +%s`;
mv log/main.log log/"$date".log;