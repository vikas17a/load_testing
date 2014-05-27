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

echo "Creating directory for the large VM" >> log/main.log;
mkdir v1;
echo "Directory created" >> log/main.log;

echo "Copying VagrantFile for large VM" >> log/main.log;
cp ../VagrantFile v1/;
sleep 2;
echo "Vagrant file Copied" >> log/main.log;

echo "Copying package box to large machine" >> log/main.log;
cp ../package.box v1/;
echo "Copied package box" >> log/main.log;

echo "Entering into the directory of large VM" >> log/main.log;
cd v1;
echo "Entered into the directory of large VM " >> ../log/main.log;

echo "Adding box to the vagrant service for large VM" >> ../log/main.log;
vagrant box add package.box --name box1.box >> ../log/main.log &
pid=$!;
wait $pid;
echo "Box added for large vm" >> ../log/main.log;

echo "Large VM going up be safe !!!! " >> ../log/main.log;
vagrant up >> ../log/main.log &
pid=$!;
wait $pid;
echo "Large VM is up" >> ../log/main.log;

cd ..;
echo "Out of Large Vm directory" >> log/main.log;

echo "Creating worker file for largevm " >> log/main.log;
echo "cp /sync_folder/out ." >> work_lm.sh;
echo "awk '{print \$2}' out | sort | uniq -c | sort -nr | head -n 30 > final_result;" >> work_lm.sh;
echo "sudo cp final_result /sync_folder/" >> work_lm.sh;
echo "Worker file created for largevm " >> log/main.log;

echo "Processing up large vm with worker file" >> log/main.log;
echo "Entered into the directory of largevm" >> log/main.log;
cd v1;
echo "Starting ssh connection with largevm" >> ../log/main.log;
vagrant ssh < ../work_lm.sh &
pid=$!;
wait $pid;
echo "Processing completed by largevm" >> ../log/main.log;
cd ..;
echo "Out of the directory of largevm" >> log/main.log;


echo "Entering into the largevm directory" >> log/main.log; 
cd v1;
echo "Destroying the largevm" >> ../log/main.log;
vagrant destroy -f;
sleep 10;
echo "Destroyed largevm :(" >> ../log/main.log;
cd ..;
echo "Out of directory of largevm"; >> log/main.log;

echo "Removing the large vm directory" >> log/main.log;
rm -r v1/;
echo "Removed large vm directory"  >> log/main.log;

echo "Removing worker files" >> log/main.log;
rm work*;

date=`date +%s`;
mv log/main.log log/"$date".log;