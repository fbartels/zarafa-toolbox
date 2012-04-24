#!/usr/bin/python -u

import sys
from MAPI import *
from MAPI.Util import *

PR_EC_OUTOFOFFICE                   = PROP_TAG(PT_BOOLEAN,    PR_EC_BASE+0x60)
PR_EC_OUTOFOFFICE_MSG               = PROP_TAG(PT_TSTRING,    PR_EC_BASE+0x61)
PR_EC_OUTOFOFFICE_SUBJECT           = PROP_TAG(PT_TSTRING,    PR_EC_BASE+0x62)

if len(sys.argv) < 3:
    print "Usage: %s <username> <1|0> [<oof_subject>] [<path/to/oof/message.txt>]" % sys.argv[0]
    exit(1)

try:
    session = OpenECSession(sys.argv[1], '', 'file:///var/run/zarafa')
    st = GetDefaultStore(session)
except MAPIError, e:
    print "Unable to open store for user"
    exit(1)

enabled = bool(int(sys.argv[2]))
st.SetProps([SPropValue(PR_EC_OUTOFOFFICE, enabled)])

if(enabled):
    if len(sys.argv) >= 4:
        st.SetProps([SPropValue(PR_EC_OUTOFOFFICE_SUBJECT, sys.argv[3])])

    if len(sys.argv) >= 5:
        f = open(sys.argv[4], 'rt')
        msg = f.read()
   
        st.SetProps([SPropValue(PR_EC_OUTOFOFFICE_MSG, msg)])
