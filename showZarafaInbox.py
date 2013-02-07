#!/usr/bin/python -u
# showZarafaInbox.py
#   This script was written by Valentin Hoebel (valentin@xenuser.org)
#   It is based on examples provided by Zarafa (especially by Steve)
#   2012-05-17

from MAPI import *
from MAPI.Struct import *
from MAPI.Util import *
from MAPI.Time import *

import locale
import sys
import string
import time
import getopt

def print_banner():
	print ""
	print ""
	print "Simple Zarafa Inbox Viewer"
	print "by Valentin Hoebel (valentin@xenuser.org)"
	print "__________________________________________"
	print ""
	return

def print_usage():
	print_banner()
	print "[!] No or wrong arguments passed. Use --help for more information."
	print "[!] Usage: ./showZarafaInbox.py --user=<username> --password=<password>"
	print "[!] Usage example: ./showZarafaInbox.py --user=valentin --password=secretone"
	print ""
	print ""

def print_help():
	print_banner()
	print ""
	print "[Description]"
	print "The Simple Zarafa Inbox Viewer tries to show you"
	print "the content of your inbox."
	print "Please note that this only works if the script is called"
	print "on the Zarafa server."
	print ""
	print "[Usage]"
	print "./showZarafaInbox.py --user=<username> --password=<password"
	print ""
	print "[Usage example]"
	print "./showZarafaInbox.py --user=valentin --password=secretone"
	print ""
	print ""
	sys.exit()
	return

def show_zarafa_inbox(username, password):
	messages=0
	#locale.setlocale(locale.LC_ALL, '')
	session = OpenECSession(username, password, 'file:///var/run/zarafa', flags = 0)
	store = GetDefaultStore(session)

	result = store.GetReceiveFolder('IPMI', 0)
	inboxid = result[0]
	inbox = store.OpenEntry(inboxid, None, 0)

	props = inbox.GetProps([PR_DISPLAY_NAME], 0)
	print "[i] Opened folder " + props[0].Value
	print "[i] Showing messages... \n"

	table = inbox.GetContentsTable(0)
	table.SetColumns([PR_ENTRYID, PR_SUBJECT, PR_SENDER_NAME], 0)
	table.SortTable(SSortOrderSet( [ SSort(PR_SUBJECT, TABLE_SORT_ASCEND) ], 0, 0), 0);
	rows = table.QueryRows(10, 0)

	for row in rows:
	        print "Subject: " + row[1].Value + "| From: " + row[2].Value;
		messages += 1		
	
	print "---------------------------------------"
	print messages, " messages shown"
	print ""
	print ""
	return

def main(argv):
	username=""
	password=""
	
	try:
		opts, args = getopt.getopt(sys.argv[1:], "", ["help", "user=", "password="])
	except getopt.GetoptError :
		print_usage()
		sys.exit(2)
	
	for opt, arg in opts:
		if opt in ("--help"):
			print_help()
			break
			sys.exit(1)
		elif opt in ("--username"):
			username=arg
		elif opt in ("--password"):
			password=arg
	
	if len(username) <2:
		print_usage()
		sys.exit()

	if len(password) <2:
		print_usage()
		sys.exit()
	
	# Continue if all required arguments were passed to the script.
	print_banner()
	print "[i] Provided Zarafa username: " + username
	show_zarafa_inbox(username, password)

if __name__ == "__main__":
	main(sys.argv[1:])
