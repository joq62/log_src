%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Create1d : 10 dec 2012
%%% -------------------------------------------------------------------
-module(handler_basic_terminal). 
     
%% --------------------------------------------------------------------
%% Include files

%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Definitions

%% --------------------------------------------------------------------
-define(StdHandlerConfig,#{config =>
				#{burst_limit_enable => true,burst_limit_max_count => 500,
				  burst_limit_window_time => 1000,drop_mode_qlen => 200,
				  filesync_repeat_interval => no_repeat,flush_qlen => 1000,
				  overload_kill_enable => false,
				  overload_kill_mem_size => 3000000,
				  overload_kill_qlen => 20000,
				  overload_kill_restart_after => 5000,sync_mode_qlen => 10,
				  type => standard_io},
			    filter_default => stop,
			    filters =>
				[{remote_gl,{fun logger_filters:remote_gl/2,stop}},
				 {domain,{fun logger_filters:domain/2,
					  {log,super,[otp,sasl]}}},
				 {no_domain,{fun logger_filters:domain/2,
					     {log,undefined,[]}}}],
			    formatter =>
				{logger_formatter,#{legacy_header => true,single_line => false}},
			    id => default,level => all,module => logger_std_h}).

%% --------------------------------------------------------------------
%% External exports
-export([start/0]).
-export([info/1]).

-export([adding_handler/1, removing_handler/1, log/2]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
info(Msg)->
    Masters=misc_oam:terminals(),
    {[ok],_}=rpc:multicall(Masters,terminal,print,[Msg],2000),
    logger:info(Msg).

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
   % [StdConfig]=logger:get_handler_config(),
    adding_handler(?StdHandlerConfig).
%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
adding_handler(Config) ->
    MyConfig=Config,
    % MyConfig = maps:get(config,Config,#{file => "zz.log"}),
    {ok, Pid} = gen_server:start(?MODULE, MyConfig, []),
    {ok, Config#{config => MyConfig#{pid => Pid}}}.

removing_handler(#{config := #{pid := Pid}}) ->
    gen_server:stop(Pid).

log(LogEvent,#{config := #{pid := Pid}} = Config) ->
    gen_server:cast(Pid, {log, LogEvent, Config}).

%init(#{file := File}) ->
%    {ok, Fd} = file:open(File, [append, {encoding, utf8}]),
%    {ok, #{file => File, fd => Fd}}.

init(State) ->
    %{ok, Fd} = file:open(File, [append, {encoding, utf8}]),
    {ok, State}.

handle_call(_, _, State) ->
    {reply, {error, bad_request}, State}.

handle_cast({log, LogEvent, Config}, #{fd := Fd} = State) ->
    do_log(Fd, LogEvent, Config),
    {noreply, State}.

terminate(_Reason, #{fd := Fd}) ->
    _ = file:close(Fd),
    ok.

do_log(Fd, LogEvent, #{formatter := {FModule, FConfig}}) ->
    String = FModule:format(LogEvent, FConfig),
    io:put_chars(Fd, String).
