-module(simulations_supervisor).

-behavior(supervisor).

-include("records.hrl").

%% API
-export([start_link/1, init/1, generate_world/1, restart/0]).

start_link(WorldParameters) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, [WorldParameters]).

generate_cars(WorldParameters, 0) ->
  done.
generate_cars(WorldParameters, Amount) ->
  Pos = lists:nth(rand:uniform(4), common_defs:get_start_points(car, WorldParameters)),
  gen_server:cast(cars_generator, {add, Pos}),
  generate_cars(WorldParameters, Amount-1).


init(WorldParameters) ->
  Args = [ WorldParameters ],

  Restart = permanent,
  Shutdown = brutal_kill,

  CarsGenerator = {
    cars_generator,
    {cars_generator, start_link, Args},
    Restart, Shutdown, worker,
    [ cars_generator ]
  }.


generate_world(Parameters) ->
  simulation_cars_supervisor:plant(Parameters),

  done.

restart() ->
  simulation_cars_supervisor:kill_children(),

  done.