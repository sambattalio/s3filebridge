#!/bin/bash

# Functions

usage() {
	cat <<EOF
Usage: s3filebridge.sh -b BUCKET [-d DIR]

  -h | --help        Display usage message.
  -b | --bucket      [REQUIRED] Set the s3 bucket to mirror directory.
  -d | --directory   Set the directory to monitor (Defaults to cwd).
EOF
	exit $1
}

# Default variables
DIR=$(pwd)
BUCKET=""

# parse cli options
while [ $# -gt 0 ]; do
	case $1 in
	-h | --help) usage 0;;
	-d | --directory) DIR="$2"; shift;;
	-b | --bucket) BUCKET="$2"; shift;;
	*) usage 1;;
	esac
	shift
done

# check required flag
if [[ ! "$BUCKET" =~ ^s3://[a-zA-Z0-9.\-_]{0,255}$ ]]; then
	usage 1
fi

# create bucket if not exist
aws s3 mb $BUCKET

echo "${ARGS[@]}"

# turn on monitor
fswatch -0 $DIR | while read -d "" event
	do
		aws s3 sync $DIR $BUCKET --delete
		if [ $? -ne 0 ]; then
			echo "Error updating $event"
			pkill -f "fswatch -0 $DIR"
		fi
	done
