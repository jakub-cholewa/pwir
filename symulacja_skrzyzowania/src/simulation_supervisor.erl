-module(simulation_supervisor).

-behavior(supervisor).

-include("../include/records.hrl").

%% API
-export([start_link/1, start_simulation/1, stop_simulation/0, generate_cars/2, init/1]).

start_link(WorldParameters) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, [WorldParameters]).

start_simulation(WorldParameters) ->
  generate_cars(WorldParameters, WorldParameters#world_parameters.cars_start_amount),
  done.

stop_simulation() ->
%%  traffic:kill_children(),
  done.

generate_cars(_WorldParameters, 0) ->
  done;
generate_cars(WorldParameters, Amount) ->
  Position = lists:nth(rand:uniform(4), basic_actions:get_start_points(car, WorldParameters)),
  gen_server:cast(cars_generator, {add, Position}),
  generate_cars(WorldParameters, Amount-1).


init(WorldParameters) ->
  Args = [WorldParameters],

  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = brutal_kill,
  Type = supervisor,

  CarsGenerator = {
    cars_generator,
    {cars_generator, start_link, Args},
    Restart, Shutdown, worker,
    [ cars_generator ]
  },


  {ok, {SupFlags, [CarsGenerator]}}.
%%  {ok, {SupFlags, [UUIDProvider, CarsGenerator, PedestriansSupervisor, TrafficSupervisor, Light]}}.