-module(simulation_main_supervisor).
-behavior(supervisor).

-include("records.hrl").

-export([start_link/1, init/1]).
-export([generate_world/1, start_simulation/1, stop_simulation/0, generate_cars/2]).

start_link(WorldParameters) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, WorldParameters).

start_simulation(WorldParameters) ->
  simulations_supervisor:start_simulation(WorldParameters).

stop_simulation() ->
  simulations_supervisor:stop_simulation().

generate_cars(WorldParameters, Amount) ->
  simulations_supervisor:generate_cars(WorldParameters, Amount).


init(WorldParameters) ->
  Args = [WorldParameters],

  SimulationController = {
    simulation_controller,
    {simulation_controller, start_link, Args},
    permanent,
    1000, %% max restarts
    worker,
    [simulation_controller]},

  SimulationsSupervisor = {
    simulations_supervisor,
    {simulation_simulations_supervisor},
    permanent,
    brutal_kill,
    supervisor,
    [simulation_simulations_supervisor]},

  EventStream = {
    simulation_event_stream,
    {simulation_event_stream, start_link, []},
    pernament,
    1000,
    worker,
    [simulation_event_stream]},

  {ok, {{one_for_one, 1, 60}}}.

generate_world(WorldParameters) ->
  simulation_simulations_supervisor:generate_world(WorldParameters).


