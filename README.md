# S3 File Bridge

Works on MacOS. 

Uses AWS CLI `aws s3 sync` on target bucket whenever the directory has an update.

This can be used to make a directory work like a dropbox / googledrive folder.

## Usage

`s3filebridge.sh -b BUCKET [-d DIR]`

Then, it will run detecting changes on the directory, syncing when triggered.

## Requirements

`brew install fswatch`
