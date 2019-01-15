%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. sty 2019 22:25
%%%-------------------------------------------------------------------
-module(simulation_default_handler).
-behavior(gen_event).
-author("kuba").

%% API
-export([init/1, handle_event/2, code_change/3, handle_call/2, handle_info/2, terminate/2]).

init(_Args) ->
  {ok, []}.

handle_event(Msg, State) ->
  io:format("Event: ~w ~n", Msg),
  {ok, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

handle_call(_Request, State) ->
  {ok, empty, State}.

handle_info(_Info, State) ->
  {ok, State}.

terminate(_Args, _State) ->
  ok.


