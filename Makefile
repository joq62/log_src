all:
	erlc -o ebin src/*.erl;
	rm -rf 1_ebin/* test_ebin/* ebin/* */*.beam *.beam ebin/*;
	rm -rf  *~ */*~  erl_cra* *.log;
	echo Done
doc_gen:
	echo glurk not implemented
stop:
	erl_call -a 'rpc call [log_termin@c0 init stop []]' -sname master -c abc;
	erl_call -a 'rpc call [log_terminal@c1 init stop []]' -sname master -c abc;
	erl_call -a 'rpc call [log_terminal@c2 init stop []]' -sname master -c abc
log_terminal:
	rm -rf 1_ebin/* src/*.beam *.beam;
	rm -rf  *~ */*~  erl_cra*;
#	common
	erlc -o 1_ebin ../common_src/src/*.erl;
#	application terminal
	erlc -o 1_ebin ../terminal_src/src/*.erl;
	erl -pa 1_ebin -s terminal start -sname log_terminal -setcookie abc
alert_ticket_terminal:
#	rm -rf 1_ebin/* src/*.beam *.beam;
#	rm -rf  *~ */*~  erl_cra*;
#	common
	erlc -o 1_ebin ../common_src/src/*.erl;
#	application terminal
	erlc -o 1_ebin ../terminal_src/src/*.erl;
	erl -pa 1_ebin -s terminal start -sname alert_ticket_terminal -setcookie abc
test:
	rm -rf test_ebin/* ebin/* test_src/*.beam src/*.beam *.beam;
	rm -rf  *~ */*~  erl_cra* *.log;
#	common
	erlc -o ebin ../common_src/src/*.erl;
#	application 
	erlc -o ebin src/*.erl;
#	test
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s syslog_unit_test start -sname syslog -setcookie abc
