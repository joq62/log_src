%% This is the application resource file (.app file) for the 'base'
%% application.
{application, syslog_unit_test,
[{description, "syslog_unit_test  " },
{vsn, "1.0.0" },
{modules, 
	  [syslog_unit_test_app,syslog_unit_test_sup,syslog_unit_test]},
{registered,[syslog_unit_test,control,syslog,common]},
{applications, [kernel,stdlib]},
{mod, {syslog_unit_test_app,[]}},
{start_phases, []}
]}.
