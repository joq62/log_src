all:
	erlc -o ebin src/*.erl;
	rm -rf ebin/* src/*.beam *.beam log_ebin/*;
	rm -rf  *~ */*~  erl_cra* *.log;
	echo Done
doc_gen:
	echo glurk not implemented
stop:
	erl_call -a 'rpc call [log_termin@c0 init stop []]' -sname master -c abc;
	erl_call -a 'rpc call [log_terminal@c1 init stop []]' -sname master -c abc;
	erl_call -a 'rpc call [log_terminal@c2 init stop []]' -sname master -c abc
log_terminal:
	rm -rf log_ebin/* src/*.beam *.beam;
	rm -rf  *~ */*~  erl_cra*;
	erlc -o log_ebin src/terminal.erl;
	erl -pa log_ebin -s terminal start -sname terminal -setcookie abc
test:
	rm -rf ebin/* src/*.beam *.beam;
	rm -rf  *~ */*~  erl_cra*;
	erlc -o ebin src/*.erl;
	erl -pa ebin -s log_unit_tests start -sname log_test -setcookie abc
