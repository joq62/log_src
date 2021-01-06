%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(event_test).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/logger.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]).



%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
    ?debugMsg("Start setup"),
    ?assertEqual(ok,setup()),
    ?debugMsg("stop setup"),
    
    ?debugMsg("Start test_1"),
    ?assertEqual(ok,test_1()),
    ?debugMsg("stop test_1"),

    ?debugMsg("Start test_2"),
    ?assertEqual(ok,test_2()),
    ?debugMsg("stop test_2"),

 
    ?debugMsg("Start test_format_term"),
    ?assertEqual(ok,test_format_term()),
    ?debugMsg("stop test_format_term"),
    
   
      %% End application tests
    ?debugMsg("Start cleanup"),
    ?assertEqual(ok,cleanup()),
    ?debugMsg("Stop cleanup"),

    ?debugMsg("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
% {{date(),time()},Severity,Info,   node(),Module,Line]
%   term() term()   atom    string  atom    atom   int
% 
-define(LOG(Severity,Msg,Node,Module,Line),
	[{{timestamp,{date(),time()}},{severity,Severity},{message,Msg},{node,Node},{module,Module},{line,Line}}]).

test_format_term()->
    
    File="glurk.tabort",
    file:delete(File),
    I1={alert,{error_in_call_to, module,function,[22,20]},node(),?MODULE,?LINE},
    log_files:write_log_file(File,I1),

    I2={ticket,{"restart control at node" },node(),?MODULE,?LINE},
    log_files:write_log_file(File,I2),
    
    I3={info,{"Started application","control_100.app_spec","host","c0"},node(),?MODULE,?LINE},
    log_files:write_log_file(File,I3),

    io:format("file:consult(File) = ~p~n",[file:consult(File)]),
    ok.



    

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
test_2()->
    ?assertMatch({_,
		  [{"./glurk.log",0,{{2021,1,5},{23,33,45}}},
		   {"./glurk1.log",0,{{2021,1,6},{0,6,56}}},
		   {"./myhandler2.log",403,{{2021,1,6},{18,47,21}}},
		   {"./master_log.log",_,_}]},
		 log_files:size_all(".")),

    
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
test_1()->
%    ?assertMatch({ok,_},
%		 gen_event:start({local,log_event})),
    
%    ?assertMatch(ok,
%		 gen_event:add_handler(log_event,log_event,[])),
    ?assertMatch(ok,
		 master_log:start()),
    ?assertMatch(ok,
		 gen_event:notify(master_log,{alert,"Alert Info 1"})),
    ?assertMatch(ok,
		 gen_event:notify(master_log,{ticket,"Ticket Info 1"})),
    ?assertMatch(ok,
		 gen_event:notify(master_log,{log,"Log Info 1"})),
    
    
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
  
    init:stop(),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
