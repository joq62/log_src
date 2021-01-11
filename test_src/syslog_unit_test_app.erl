%% Author: uabjle
%% Created: 10 dec 2012
%% Description: TODO: Add description to application_org
-module(syslog_unit_test_app).

-behaviour(application).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Behavioural exports
%% --------------------------------------------------------------------
-export([
	 start/2,
	 stop/1
        ]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([]).

%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(TestConfig,"test_src/test.config").
%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% API Functions
%% --------------------------------------------------------------------


%% ====================================================================!
%% External functions
%% ====================================================================!
%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%% --------------------------------------------------------------------
start(_Type, _StartArgs) ->
    {ok,Info}=file:consult(?TestConfig),
%    {Application,KeyGitUser,GitUser}=lists:keyfind(git_user,2,Info),
%    {Application,KeyPw,Pw}=lists:keyfind(git_pw,2,Info),
%    {Application,KeyAppSpecsDir,AppSpecsDir}=lists:keyfind(app_specs_dir,2,Info),

    [application:set_env(App,Par,Value)||{App,Par,Value}<-Info],
    io:format("All application envs ~p~n",[application:get_all_env()]),
    {ok,Pid}= syslog_unit_test_sup:start_link(),
    {ok,Pid}.
   
%% --------------------------------------------------------------------
%% Func: stop/1
%% Returns: any
%% --------------------------------------------------------------------
stop(_State) ->
    ok.

%% ====================================================================
%% Internal functions
%% ====================================================================

