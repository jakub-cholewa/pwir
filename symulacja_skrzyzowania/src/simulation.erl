-module(simulation).

-behavior(application).

-include("../include/records.hrl").

-export([ start/2, stop/1 ]).


read_world_parameters_from_settings() ->
  Width = application:get_env(symulacja_skrzyzowania, width, 70),
  Height = application:get_env(symulacja_skrzyzowania, height, 70),

  #world_parameters{
    width = Width,
    height = Height}.

start(_Type, _Args) ->
  Parameters = read_world_parameters_from_settings(),
  main_supervisor:start_link(Parameters).


stop(_State) ->
  ok.
