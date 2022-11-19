#!/bin/bash
# Written by: Buğra Sipahioğlu
# A shell script to run a given program with different compilers, threads and matrices.
# Last updated on: July/19/2019
# -----------------------------------------------------------


# If there are less than 6 parameters entered, rise an error with a documentation.
showReadMe() {	
if [ $1 -ne 6 ]
then
	echo -e "You need to enter 6 parameters.\n
		Sample Format: ./runnable.sh compiler num_threads debug lib_path matrixID_list icc_path\n
		1-	compiler: g++, clang++... Enter the binary file path of the compiler if you use icpc. \n
		2-	num_threads: enter \"0\" to use all processors\n
		3-	debug: \"-g\" if  debug, else \"--\"\n
		4-	lib_path: enter the external library path\n
		5-	matrixID_list: enter the name  of a file which has a list of matrix IDs.\n
		6-	icc_path: enter the path to binary file for icc or icpc compiler. If not using neither, enter \"--\"\n"
	exit 1
fi
}


# Checks if a file in given path exists. If not, exists the code. 
isFile() {
	[ ! -f "$1" ] && { echo "$1  does not lead to a file."; exit 1; } 
}

# Checks if a given directory exists. If not, exists the code. 
isDirectory() {
	[ ! -d "$1" ] && { echo "Directory $1  does not exist."; exit 1; } 
}



# If any of the user parameters entered incorrectly, rises a detailed error and exits the program.
validateParameters() {


if [ $num_threads -gt $num_max_threads ]
then
	echo -e "You entered $num_threads threads. Number of processors, i.e. maximum threads allowed: $num_max_threads"
	exit 1

elif [ $num_threads -lt 0 ]
then
	echo "Number of threads cannot be smaller than 0. Make it 0 if you want to use all processors."
 	exit 1

# If number of thread is equal to 0, make it the number of processors.
elif [ $num_threads -eq 0 ]
then
	num_threads=$num_max_threads
fi

# If debug is given as "--", assign debug variable to " " since "--" cannot be a parameter.
if test "$debug" = "--"
then
	debug=" "

elif test "$debug" != "-g"
then
	echo "You entered invalid argument for debug. Enter either \"-g\" or \"--\""
	exit 1	
fi

# If icc compiler has been selected but the path is given "--", rise an error.
if test "$compiler" = "icc" || test "$compiler" = "icpc"
then
	if test "$icc_path" = "--"
	then
		echo -e "You need to enter ic(p)c path if you want to use icc compiler."
		exit 1
	fi
	
	isFile $icc_path
	#[ ! -f "$icc_path" ] && { echo "ic(p)c file $icc_path  DOES NOT exists."; exit 1; } 
fi


isDirectory $lib_path
#[ ! -d "$lib_path" ] && { echo "Library directory $lib_path  DOES NOT exist."; exit 1; }


isFile $matrixID_list
#[ ! -f "$matrixID_list" ] && { echo "Matrix ID list file  $matrixID_list DOES NOT exist."; exit 1; }


}

# Construct the executable file name with respect to compiler and debug option
constructOutputFile() {

[ "$debug" = " " ] && out_file="main_$compiler" || out_file="main_${compiler}_g"

}


# If icc or icpc compiler has been selected, assign the $compiler to path
constructCompiler() {

[ "$compiler" = "icc" ] || [ "$compiler" = "icpc" ] && compiler="$(echo $icc_path)"


# If clang or clang++ compiler has been selected, assign the result to a boolean variable
[ "$compiler" = "clang" ] || [ "$compiler" = "clang++" ] && is_clang=true || is_clang=false

}




compile() {


LD_LIBRARY_PATH=$lib_path ; export LD_LIBRARY_PATH


if [ "$is_clang" = true ] 
then
	#Compile without giving a output file name

	#$compiler $debug <Your Files Here> 
	
	if [ -f "a.out" ]
	then
		size="$(wc -c < "a.out")"

		if [ $size -gt 0 ]
		then
			# output file successfully created
			mv a.out $out_file
			
		else
			echo "Failed to compile. Output file has zero bytes." 
			exit 1
		fi
	else
		echo "Output file cannot be created."
		exit 1
	fi

else
	#Compile here and above
	#$compiler $debug <Your Files Here> -o $out_file

	if [ -f "$out_file" ]
	then
		size="$(wc -c < "$out_file")"
		[ $size -gt 0 ] || { echo "Output file has zero bytes." ; exit 1 ; }
	else
		echo "Output file cannot be created"
		exit 1
	fi
fi
}

# Run the compiled program for all the matrix IDs.
run() {
 
	# For the time being, record the while loops run-time.
	SECONDS=0

	# Run the program with all the matrix IDs in the given list.
	while IFS= read -r matrixID
	do
		#RUN YOUR CODE HERE
		echo $matrixID
		./$out_file $matrixID &>> $matrixID.$num_threads
	done < $matrixID_list

	ELAPSED="While Loop Run-time Information: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
	echo -e "\n$ELAPSED\n"
}



# Assign user parameters to global variables
compiler=$1
num_threads=$2
debug=$3
lib_path=$4       
matrixID_list=$5  
icc_path=$6 	  

# Get the maximum number of threads usable, i.e. the number of available cores
num_max_threads="$(getconf _NPROCESSORS_ONLN)"

# Get the number of arguments
num_args=$#

main() {

	showReadMe $#

	validateParameters

	constructOutputFile

	constructCompiler

	compile

	run

	exit 0

}

main
