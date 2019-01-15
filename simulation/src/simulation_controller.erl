%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. sty 2019 20:09
%%%-------------------------------------------------------------------
-module(simulation_controller).
-behavior(gen_server).
-author("kuba").

-include("records.hrl").

%% API
-export([init/1, handle_call/3, terminate/2, code_change/3, handle_cast/2, handle_info/2]).
-export([start_link/1, start_simulation/0, stop_simulation/0]).

start_link(WorldParameters) ->
  gen_server:(start_link({local, ?MODULE}, ?MODULE, WorldParameters, [])).

start_simulation() ->
  gen_server:call(?MODULE, start_simulation).

stop_simulation() ->
  gen_server:call(?MODULE, stop_simulation).

%%get_simulation_parameters() ->
%%  gen_server:call(?MODULE, get_simulation_parameters).

init(WorldParameters) ->
  simulation_event_stream:component_ready(?MODULE),
  {ok, {stopped, WorldParameters}}.

%% Starting simulation

handle_call(start_simulation, _From, {stopped, WorldParameters}) ->
  simulation_main_supervisor:generate_world(WorldParameters),
  {reply, started, {started, WorldParameters}}.

handle_call(start_simulation, _From, {started, _WorldParameters} = State) ->
  {reply, already_started, State};

%% Stopping simulation
handle_call(stop_simulation, _From, {started, State}) ->
  simulation_main_supervisor:clear_world(),
  {reply, stopped, {stopped, State}};

handle_call(stop_simulation, _From, {stopped, _WorldParameters} = State) ->
  {reply, already_stopped, State};

%% Getting simulation parameters and default `handle_call/3` handler.

handle_call(get_simulation_parameters, _From, {StateName, WorldParameters} = State) ->
  IsSimulationStarted = StateName =:= started,

  {reply, { {simulation_started, IsSimulationStarted} }, State}.

terminate(_, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.