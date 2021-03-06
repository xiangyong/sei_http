%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(sei_http_app).
-behaviour(application).

%% API.
-export([start/0,start/2]).
-export([stop/1]).

%% API.
start() ->
    lager:start(),
    application:start(crypto),
    application:start(ranch),
    application:start(cowlib),
    application:start(cowboy),
    application:start(sei_http).


start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/stat", sei_stat_handler, []},
			{"/event", sei_event_handler, []},
			{"/local", sei_local_handler, []},
			{"/test", sei_test_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
		{env, [{dispatch, Dispatch}]}
	]),
	sei_http_sup:start_link().

stop(_State) ->
	ok.
