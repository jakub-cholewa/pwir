-module(cars_generator).
-author("molion").

-behavior(gen_server).

-include("../include/records.hrl").

%% API
-export([start_link/1, init/1, terminate/2, code_change/3]).


start_link([WorldParameters]) ->
  [P1,P2,P3,P4] = basic_actions:get_start_points(car, WorldParameters),
  gen_server:start_link({local, ?MODULE}, ?MODULE, #car_generator{map = #{P1 => 0, P2 => 0, P3 => 0, P4 => 0}, world_parameters = WorldParameters}, []).

init(State) ->
  erlang:start_timer(1000, self(), loop),
  {ok, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.