##########################################################################
#                                                                        #
#    This script configures this directory for load testing              #  
#                                                                        #
##########################################################################

## Check for log directory ####

if [ ! -d "log" ]; then
	mkdir -p log;
else 
	echo "Log directory already exisits" >> log/conf.log;
fi

touch log/conf.log;
echo "#################### Started Conf   ######################" >> log/conf.log;
date >> log/conf.log;
echo "Configured Successful" >> log/conf.log;
echo "" >> log/conf.log;
echo "#################### End Conf  ###########################" >> log/conf.log;

##################################################################################
#
#                END OF SCRIPT
#
#################################################################################

