%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : test application calc
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(log_event). 

-behaviour(gen_event).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Records
-record(state,{}).
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Definitions 
-define(HeartBeatInterval,30*1000).
%% --------------------------------------------------------------------




-export([alert/1
	]).

%-export([boot_app/0,
%	 ping/0
%	]).

-export([add_handler/2,
	 delete_handler/2
	]).

-export([start/0
	]).

%% gen_server callbacks
-export([init/1, handle_call/2,handle_event/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

%% Asynchrounus Signals

%% Gen server functions

start()-> 
    {ok,_}=gen_event:start_link({local, ?MODULE}),
    ok=add_handler(?MODULE,[]).

add_handler(Handler,Args)-> 
    gen_event:add_handler(?MODULE,Handler,Args).
delete_handler(Handler,Args)-> 
    gen_event:delete_handler(?MODULE,Handler,Args).




%%-----------------------------------------------------------------------
%ping()->
 %%   gen_event:call(?MODULE, {ping}).

alert(Info)->
    gen_event:event(?MODULE,{alert,Info}).


%%-----------------------------------------------------------------------

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
     io:format("Started event servert~p~n",[{?MODULE,?LINE}]),
    {ok, #state{}}.
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
handle_event({alert,Alert}, State) ->
    io:format("Alert Event~p~n",[Alert]),
    {ok, State};
handle_event({ticket,Ticket}, State) ->
    io:format("ticket Event~p~n",[Ticket]),
    {ok, State};
handle_event({log,Log}, State) ->
    io:format("log Event~p~n",[Log]),
    {ok, State};

handle_event(Event, State) ->
    io:format("unmatched match Event~p~n",[{Event,State,?MODULE,?LINE}]),
    {ok, State}.

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

handle_call(Request, State) ->
    Reply = {unmatched_signal,?MODULE,Request},
    {ok, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {ok, State}.


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
