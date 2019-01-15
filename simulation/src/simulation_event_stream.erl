%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. sty 2019 21:49
%%%-------------------------------------------------------------------
-module(simulation_event_stream).
-author("kuba").

%% API
-export([start_link/0, component_ready/1, notify/3, notify/4, attach_handler/1, remove_handler/1]).

start_link() ->
  {ok, Pid} = gen_event:start_link({local, ?MODULE}),
  gen_event:add_handler(?MODULE, simulation_default_handler, []),
  component_ready(?MODULE),
  {ok, Pid}.

component_ready(Name) ->
  gen_event:notify(?MODULE, {Name, ready}).

notify(Name, Action, State) ->
  gen_event:notify(?MODULE, {Name, Action, State}).

notify(Name, Pid, Action, State) ->
  gen_event:notify(?MODULE, {Name, Pid, Action, State}).

attach_handler(Handler) ->
  gen_event:add_handler(?MODULE, Handler, []).

remove_handler(Handler) ->
  gen_event:delete_handler(?MODULE, Handler, []).