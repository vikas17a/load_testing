load_testing (BETA)
============
This project is about to automate the load testing. Load testing is test to know about out server capability to get this work done.

Usage
=====
This script requires proper usage :
`sh start.sh <HEALTHKART ACCESS FILE>`

Files
=====
This project contains some file as follow :
- start.sh  ---> Create new vagrant machines and initiate all other scripts
- load.sh   ---> This is a auto genrated file that start loading the server
- parse.sh  ---> This is a parser file which will parse the file

ALGORITHM
=========
The work flow of this script is as follow : 
- spawn 3 VM's to start parsing the big log file
- Each VM parse 1/3rd of the file and keep it at common directory
- All three VM's will be destroyed and start large VM
- The large VM will spawn that number of requests to the server and will report into file.

Credits and Regards
===================
Created by Vikas Aggarwal under esteemed guidance of Rahul Agarwal, Nitin Wadhawan and P.Singh

```
Note : This project requires following dependencies 
1. Httperf
2. Vagrant Installed
3. JSON parser
4. Virtual Box
5. Working high bandwidth internet connection
```

