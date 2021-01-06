all:
	erlc -o ebin src/*.erl;
	rm -rf ebin/* src/*.beam *.beam 1_ebin/*;
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
	cp ../../applications/terminal_application/src/*.app 1_ebin;
	erlc -o 1_ebin ../../applications/terminal_application/src/*.erl;
	erl -pa 1_ebin -run terminal boot_app -sname log_terminal -setcookie abc
alert_ticket_terminal:
#	rm -rf 1_ebin/* src/*.beam *.beam;
#	rm -rf  *~ */*~  erl_cra*;
#	common
	erlc -o 1_ebin ../common_src/src/*.erl;
#	application terminal
	erlc -o 1_ebin ../terminal_src/src/*.erl;
	cp ../../applications/terminal_application/src/*.app 1_ebin;
	erlc -o 1_ebin ../../applications/terminal_application/src/*.erl;
	erl -pa 1_ebin -run terminal boot_app -sname alert_ticket_terminal -setcookie abc
test:
	rm -rf ebin/* src/*.beam *.beam;
	rm -rf  *~ */*~  erl_cra*;
#	common
	erlc -o ebin ../common_src/src/*.erl;
	erlc -o ebin src/*.erl;
	erl -pa ebin -s log_unit_tests start -sname log_test -setcookie abc
