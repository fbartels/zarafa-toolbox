#!/bin/bash

VERSION=0.1.1
MYSQL=mysql 
MYSQLDUMP=mysqldump                   

usage()
{
cat << EOF

USAGE: $0 [OPTIONS] [PATH|FILENAME]
   This script creates backup of zarafa database with mysqldump and compress the
   output file. By default it'll create a backup file in current working path
   with default filename. The default filename contains timestamp like
   zarafa-mysql-backup_YYYY-MM-DD_hhmm.gz if you just enter path, then the path
   will be used with default filename

OPTIONS:
	--mysql-password PASSWORD
		Password for zarafa database in MySQL (not recommended as
		parameter because it'll echoed in commandline & stored in
		bash-history)
	--mysql-login USERNAME
		Username for zarafa database in MySQL
	--max-allowed-packet MAX_ALLOWED_PACKET
		Max allowed Packet in MySQL (e.g. 25M)
	-h, --help
		Show this help text
	-V, --version
		Display version information
EOF
}

# get comandline parameters
while [[ $1 == -* ]]; do
	case "$1" in
		-h|--help)
			usage
			exit 0
			;;
		--mysql-host*)
			if (($# > 1));then
				MYSQLHOST=$2; shift;
			else
				echo "$1 requires an argument"
				exit 1
			fi
			shift;;
		-l|--mysql-login)
			if (($# > 1));then
				MYSQLUSER=$2; shift;
			else
				echo "$1 requires an argument"
				exit 1
			fi
			shift;;
		--max-allowed-packet)
			if (($# > 1));then
				MAX_ALLOWED_PACKET=$2; shift;
			else
				echo "$1 requires an argument"
				exit 1
			fi
			shift;;
		-p|--mysql-password)
			if (($# > 1));then
				MYSQLPWD=$2; shift;
			else
				echo "$1 requires an argument"
				exit 1
			fi
			shift;;
		-V|--version)
			echo $0 Version $VERSION
			exit 0
			;;
		-*)
			echo "Invalid option: $1" >&2
			usage
			exit 1
			;;
		--) shift; break;;
	esac
done

# path & filename
if [ -z $1 ];
then
	BACKUPFILE=./zarafa-mysql-backup_`date +%Y-%m-%d_%H%M`.gz
else
	if [[ -d $1 || $1 = */ ]];
	then
		BACKUPFILE=$1/zarafa-mysql-backup_`date +%Y-%m-%d_%H%M`.gz
	else
		BACKUPFILE=$1
	fi
fi

# mysql parameters
MYSQLHOST=${MYSQLHOST:-localhost}
if [ -z $MYSQLUSER ];
then
	read -p "Please enter username for MySQL (zarafa DB): " MYSQLUSER
	if [ -z $MYSQLUSER ];
	then
		echo "Error: No username entered!"
		exit 1
	fi
fi

if [ -z $MYSQLPWD ];
then
	stty -echo
	read -p "Please enter password for MySQL (zarafa DB): " MYSQLPWD
	echo
	stty echo
fi

# CREATE MYSQL BACKUP
COMMAND="$MYSQLDUMP -u$MYSQLUSER -p$MYSQLPWD -h$MYSQLHOST"
if [ "$MAX_ALLOWED_PACKET" ];
then
	COMMAND="$COMMAND --max_allowed_packet=$MAX_ALLOWED_PACKET"
fi

COMMAND="$COMMAND --single-transaction --skip-opt --quick zarafa"
echo Please wait, it may take some minutes. It depends on size of zarafa database.
$COMMAND | /bin/gzip > $BACKUPFILE;
