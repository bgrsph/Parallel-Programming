#!/bin/bash
# Written by: Buğra Sipahioğlu
# A shell script to run the specified program, then send a mail about run time information to a mail address 
# Last updated on: July/19/2019
# -----------------------------------------------------------

# Set up the mail properties
target_mail=mail@example.com
subject="Results"
out_file="exp_out.txt"

# Get the command line arguments
compiler=$1
num_threads=$2
debug=$3
lib_path=$4
matrixID_list=$5
icc_path=$6

#Run the program with time and save the output to a file
$( which time ) -o $out_file ./test.sh $compiler $num_threads $debug $lib_path $matrixID_list $icc_path

#If there are no errors, send e-mail. Else, warn the user
if [ $? -ne 0 ]
then
	echo "Program exit with non-zero code. Check for the file \"$out_file\" to see run-time results."
	exit 1
	
else
	# Mail the output file to the target address
	mail -s "$subject" $target_mail -A $out_file < /dev/null
	
	# If mail command is failed to run, suggest a mail-setup link for the user
	if [ $? -ne 0 ]
	then
		echo "Mail command has failed. For server setup, see: https://kifarunix.com/configure-postfix-to-use-gmail-smtp-on-ubuntu-18-04/"
		exit 1
	else
		echo "Please check your e-mail for the run-time results. You can also look $out_file too."
	fi
fi

# For the time being, show the time results to user. 
echo -e "\nRun-time of whole script: \n"
cat $out_file

exit 0
