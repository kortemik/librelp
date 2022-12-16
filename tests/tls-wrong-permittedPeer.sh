#!/bin/bash
. ${srcdir:=$(pwd)}/test-framework.sh
export errorlog="error.$LIBRELP_DYN.log"
export TLSLIB="-l openssl"
startup_receiver -T -a "name" -x ${srcdir}/tls-certs/ca.pem \
	-y ${srcdir}/tls-certs/cert.pem -z ${srcdir}/tls-certs/key.pem \
	-P "wrong name" -e $TESTDIR/$errorlog

echo 'Send Message...'
./send $TLSLIB -t 127.0.0.1 -p $TESTPORT -m "testmessage" -T -a "name" \
	-x ${srcdir}/tls-certs/ca.pem -y ${srcdir}/tls-certs/cert.pem \
	-z ${srcdir}/tls-certs/key.pem -P "wrong name" -e $TESTDIR/$errorlog $OPT_VERBOSE

stop_receiver
check_output "authentication error.*no permited name found.*testbench.rsyslog.com" $TESTDIR/$errorlog
terminate
