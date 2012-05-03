#!/bin/bash
## Searches the Zarafa attachments directory and replaces duplicate files 
## with hardlinks
## Requires the Debian packages "hardlink" to be installed
## remove the "n" to actually do anything.
hardlink -tnv /var/lib/zarafa/ -x index
