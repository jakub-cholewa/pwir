-module(simulation_defaults).

-include("records.hrl").


%% API
-export([stop_children/1, get_start_points/2, ask_cars_for_position/4, random_direction/0]).

stop_children(SupervisorName) ->
  [ Pid ! stop_entity || {_, Pid, _, _} <- supervisor:which_children(SupervisorName) ].

random_direction() ->
  case rand:uniform(3) of
    1 -> forward;
    2 -> left;
    3 -> right
  end.


get_start_points(car,_WorldParameters) ->
  [
    #position{x = 8, y = -1, look_x = 0, look_y = 1},
    #position{x = 16, y = 8, look_x = -1, look_y = 0},
    #position{x = 7, y = 16, look_x = 0, look_y = -1},
    #position{x = -1, y = 7, look_x = 1, look_y = 0}
  ].



ask_cars_for_position([], _NxtPositionPositionX, _NxtPositionPositionY, _MyPid) -> free;
ask_cars_for_position([ {_Id, MyPid, _Type, _Modules} | Rest ], NxtPositionPositionX, NxtPositionPositionY, MyPid) ->
  ask_cars_for_position(Rest,NxtPositionPositionX,NxtPositionPositionY,MyPid);
ask_cars_for_position([ {_Id, Car, _Type, _Modules} | Rest ], NxtPositionPositionX, NxtPositionPositionY, MyPid) ->
  try gen_server:call(Car, {are_you_at, NxtPositionPositionX, NxtPositionPositionY},300) of
    true ->
      Car;
    false ->
      ask_cars_for_position(Rest,NxtPositionPositionX,NxtPositionPositionY,MyPid)
  catch
    exit:_Reason ->
      timeout
  end.