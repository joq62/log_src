%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(log_normal_test).  
   
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

 
%   ?debugMsg("Start test_3"),
%    ?assertEqual(ok,test_3(2000)),
%    ?debugMsg("stop test_3"),
    
   
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
test_3(0)->
    ok;
test_3(N) ->
    logger:alert("Alert"),
    logger:notice("Notice"),
    logger:info("Info"),
    zz:alert("Alert out of disc ~n"),
    test_3(N-1).
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
test_2()->
   ?assertMatch({ok,_},
	        myhandler2:start()), 
    
    ?assertMatch(ok,logger:error("Write to file test")),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
test_1()->
    ?assertMatch({ok,_},
		 handler_basic:start()),
     ?assertMatch(ok,logger:error("Basic text test_1 ~n")),

    ?assertMatch({ok,_},
		 handler_basic_terminal:start()),
     ?assertMatch(ok,handler_basic_terminal:info("Basic text on terminal~n")),
    
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
