-module(simulation).
-behavior(application).

-include("records.hrl").

read_world_parameters() ->
  LightTime = application:get_env(crossroad, light_time, 5000),
  YellowLightTime = application:get_env(crossroad, light_time, 3000),
  CarNumber = application:get_env(crossroad, car_number, 4),

  #world_parameters{
    light_time = LightTime,
    yellow_light_time = YellowLightTime,
    car_number = CarNumber
  }.

start(_Type, _Args) ->
  WorldParameters = read_world_parameters(),
  simulation_main_supervisor:start(WorldParameters).

stop(_State) ->
  ok.