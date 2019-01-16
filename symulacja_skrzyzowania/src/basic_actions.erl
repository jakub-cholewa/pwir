-module(basic_actions).
-author("molion").

-include("../include/records.hrl").

%% API
-export([stop_children/1, random_direction/0, random_directions/1, random_directions/2, get_start_points/2, random_destination/0]).



stop_children(SupervisorName) ->
  [ Pid ! stop_entity || {_, Pid, _, _} <- supervisor:which_children(SupervisorName) ].

random_direction() ->
  case rand:uniform(3) of
    1 -> forward;
    2 -> left;
    3 -> right
  end.

random_directions(N) ->
  random_directions(N,[]).
random_directions(0,List) ->
  List;
random_directions(N,List) ->
  random_directions(N - 1, [random_direction()|List]).

random_destination() -> random_direction().


get_start_points(car,_WorldParameters) ->
  [
    #position{x = 8, y = -1, direction_x = 0, direction_y = 1},
    #position{x = 16, y = 8, direction_x = -1, direction_y = 0},
    #position{x = 7, y = 16, direction_x = 0, direction_y = -1},
    #position{x = -1, y = 7, direction_x = 1, direction_y = 0}
  ].