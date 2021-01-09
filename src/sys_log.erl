%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Manage Computers
%%% 
%%% Created : 
%%% -------------------------------------------------------------------
-module(sys_log). 

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include("timeout.hrl").
%-include("log.hrl").

%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state, {file}).



%% --------------------------------------------------------------------
%% Definitions 
%% --------------------------------------------------------------------

% OaM related
-export([alert/4,
	 ticket/4,
	 log/4]).

-export([start/0,
	 stop/0,
	 ping/0
	]).

%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

%% Asynchrounus Signals



%% Gen server functions

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).


ping()-> 
    gen_server:call(?MODULE, {ping},infinity).

%%-----------------------------------------------------------------------

%%----------------------------------------------------------------------
alert(Msg,Node,Module,Line)->
    io:format("~p~n",[{Msg,Node,Module,Line,?MODULE,?LINE}]),
    gen_server:cast(?MODULE,{alert,Msg,Node,Module,Line}).
ticket(Msg,Node,Module,Line)->
    gen_server:cast(?MODULE,{ticket,Msg,Node,Module,Line}).
log(Msg,Node,Module,Line)->
    gen_server:cast(?MODULE,{log,Msg,Node,Module,Line}).

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
    
    %% -- Append to log file
    File="./"++atom_to_list(?MODULE)++".log",

    io:format("~p~n",[{log,["Server "++?MODULE_STRING++" started at node "],node(),?MODULE,?LINE}]),
    log_files:write_log_file(File,[log,["Server "++?MODULE_STRING++" started at node "],node(),?MODULE,?LINE]),
    {ok, #state{file=File}}.
        
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------
handle_call({ping},_From,State) ->
    Reply={pong,node(),?MODULE},
    {reply, Reply, State};

handle_call({stop}, _From, State) ->
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% -------------------------------------------------------------------

handle_cast({alert,Msg,Node,Module,Line}, State) ->
    DateTime=log_files:date_time(),
    rpc:multicall(misc_oam:alert_ticket_terminals(),terminal,print,
		  ["~s~p ~p ~n                  ~p~n~n",[DateTime,alert,Msg,{Node,Module,Line}]]),   
    
    rpc:multicall(misc_oam:log_terminals(),terminal,print,
		  ["~s~p ~p ~n                  ~p~n~n",[DateTime,alert,Msg,{Node,Module,Line}]]),   
   
    io:format("~p~n",[{alert,Msg,Node,Module,Line}]),
    log_files:write_log_file(State#state.file,[alert,Msg,Node,Module,Line]),
    {noreply, State};
handle_cast({ticket,Msg,Node,Module,Line}, State) ->
    DateTime=log_files:date_time(),
    rpc:multicall(misc_oam:alert_ticket_terminals(),terminal,print,
		  ["~s~p ~p ~n                  ~p~n~n",[DateTime,ticket,Msg,{Node,Module,Line}]]),   
    
    rpc:multicall(misc_oam:log_terminals(),terminal,print,
		  ["~s~p ~p ~n                  ~p~n~n",[DateTime,ticket,Msg,{Node,Module,Line}]]),   
  
    io:format("~p~n",[{ticket,Msg,Node,Module,Line}]),
    log_files:write_log_file(State#state.file,[ticket,Msg,Node,Module,Line]),
    {noreply, State};
handle_cast({log,Msg,Node,Module,Line}, State) ->
    DateTime=log_files:date_time(),
    rpc:multicall(misc_oam:log_terminals(),terminal,print,
		  ["~s~p ~p ~n                  ~p~n~n",[DateTime,log,Msg,{Node,Module,Line}]]),
    io:format("~p~n",[{log,Msg,Node,Module,Line}]),
    log_files:write_log_file(State#state.file,[log,Msg,Node,Module,Line]),
    {noreply, State};    


handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
