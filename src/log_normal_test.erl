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
-export([start/0,
	print/1,print/2]).



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
    
  %  ?debugMsg("Start test_1"),
  %  ?assertEqual(ok,test_1()),
  %  ?debugMsg("stop test_1"),

   % ?debugMsg("Start test_2"),
  %  ?assertEqual(ok,test_2()),
  %  ?debugMsg("stop test_2"),

    ?debugMsg("Start test_3"),
    ?assertEqual(ok,test_3(2000)),
    ?debugMsg("stop test_3"),
    
   
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


exec(M,F,A,T)->
    {ok,HostId}=net:gethostname(),
    Node=list_to_atom("terminal@"++HostId),
    rpc:call(Node,terminal,exec,[M,F,A,T],T).

print(Text)->
    {ok,HostId}=net:gethostname(),
    Node=list_to_atom("terminal@"++HostId),
    rpc:cast(Node,terminal,print,[Text]). 

print(Text,List)->
    {ok,HostId}=net:gethostname(),
    Node=list_to_atom("terminal@"++HostId),
    rpc:cast(Node,terminal,print,[Text,List]).    

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
test_2()->

  ?assertEqual(ok,logger:error("error eexist file")),

  %% Print log to a file
    ?assertEqual(ok,logger:set_handler_config([default,
					       #{config => 
						     #{file =>"erlang.log",
						       max_no_bytes =>100,
						       max_no_files =>2}}])),
		 
    ?assertEqual(ok,logger:error("error eexist file")),
    
    ?assertEqual(ok,os:cmd("cat erlang.log")),
    
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
test_1()->
    ?assertEqual(ok,exec(logger,i,[primary],2000)),
    ?assertEqual(ok,exec(logger,i,[handlers],2000)),

    % Default set up
     ?assertEqual(ok,exec(logger,error,["error eexist file"],2000)),
    
    %% Formatter update
    ?assertEqual(ok,exec(logger,set_handler_config,
			 [default,formatter,{logger_formatter,
					     #{ template =>[time," ",file,":",line," ",level,":",msg,"\n"]}}],2000)),

    ?assertEqual(ok,exec(logger,error,["Test module line ",#{file=>?FILE, line=>?LINE}],2000)),

    %% Print log to a file
    ?assertEqual(ok,exec(logger,set_handler_config,[default,#{config => #{file =>"erlang.log",
									  max_no_bytes =>100,
									  max_no_files =>2}},
							      #{formatter => {logger_formatter, #{}}}],2000)),
		 
    ?assertEqual(ok,exec(logger,error,["Test module line "],2000)),
    
    ?assertEqual(ok,exec(os,cmd,["cat erlang.log"],2000)),
					     
    
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
