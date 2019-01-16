-module(simulations_supervisor).

-behavior(supervisor).

-include("records.hrl").

%% API
-export([start_link/1, init/1, generate_world/1,
  restart/0, start_simulation/1, stop_simulation/0]).
%%  restart/0, start_simulation/1, stop_simulation/0,
%%  start_lights/1, stop_lights/0]).


start_link(WorldParameters) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, [WorldParameters]).

start_simulation(WorldParameters) ->
  start_lights(WorldParameters),
  generate_cars(WorldParameters, WorldParameters#world_parameters.cars_start_amount),
  done.

stop_simulation() ->
  stop_lights(),
  %simulation_traffic_supervisor:kill_children(),
  done.

%% Lights
%start_lights(WorldParameters) ->
%  gen_statem:call(light_entity, start).
%%
%%stop_lights() ->
%%  simulation_defaults:stop_children(?MODULE).

%% Cars
generate_cars(WorldParameters, 0) ->
  done;
generate_cars(WorldParameters, Amount) ->
  Pos = lists:nth(rand:uniform(4), simulation_defaults:get_start_points(car, WorldParameters)),
  gen_server:cast(cars_supervisor, {add, Pos}),
  generate_cars(WorldParameters, Amount-1).

%% Supervisor callbacks
init(WorldParameters) ->
  Args = [ WorldParameters ],

  CarsSupervisor = {
    cars_supervisor,
    {cars_supervisor, start_link, Args},
    permanent, brutal_kill, supervisor,
    [ cars_supervisor ]
  },

%%  Light = {
%%    light_enity,
%%    {light_entity, start_link, Args},
%%    temporary, brutal_kill, supervisor,
%%    [ light_entity ]
%%  },
%%
%%  {ok, [CarsSupervisor, Light]}.
  {ok, [CarsSupervisor]}.


%%generate_world(Parameters) ->
%%  simulation_cars_supervisor:spawn(Parameters),
%%
%%  done.

restart() ->
  simulation_cars_supervisor:kill_children(),

  done.