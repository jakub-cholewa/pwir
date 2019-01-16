-module(main_supervisor).

-behavior(supervisor).

-include("../include/records.hrl").

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-export([start_simulation/1,stop_simulation/0,generate_cars/2]).


start_link(WorldParameters) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, WorldParameters).

start_simulation(WorldParameters) ->
  simulations_supervisor:start_simulation(WorldParameters).

stop_simulation() ->
  simulations_supervisor:stop_simulation().

generate_cars(WorldParameters, Amount) ->
  simulations_supervisor:generate_cars(WorldParameters, Amount).

%%add_socket_handler() ->
%%  simulation_event_stream:add_socket_handler().

init(WorldParameters) ->
  Args = [ WorldParameters ],
  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 2000,
  Type = worker,

%%  Controller = {
%%    controller,
%%    {controller, start_link,Args},
%%    Restart,
%%    Shutdown,
%%    Type,
%%    [controller]
%%  },
%%
%%  EventStream = {
%%    event_stream,
%%    {event_stream,start_link,[]},
%%    Restart,
%%    Shutdown,
%%    Type,
%%    [vent_stream]
%%  },

  SimulationsSupervisor = {
    simulations_supervisor,
    {simulations_supervisor, start_link, Args},
    Restart,
    brutal_kill,
    supervisor,
    [simulations_supervisor]
  },

  {ok, {SupFlags, [SimulationsSupervisor]}}.
%%  {ok, {SupFlags, [EventStream, Controller, SimulationsSupervisor]}}.
