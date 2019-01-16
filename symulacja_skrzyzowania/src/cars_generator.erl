-module(cars_generator).

-behavior(gen_server).

-include("../include/records.hrl").

%% API
-export([start_link/1, init/1, terminate/2, code_change/3, handle_info/2, handle_cast/2, handle_call/3]).


start_link([WorldParameters]) ->
  [P1,P2,P3,P4] = basic_actions:get_start_points(car, WorldParameters),
  gen_server:start_link({local, ?MODULE}, ?MODULE, #car_generator{map = #{P1 => 0, P2 => 0, P3 => 0, P4 => 0}, world_parameters = WorldParameters}, []).

init(State) ->
  erlang:start_timer(1000, self(), loop),
  {ok, State}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({add,Pos}, State) ->
  Map = State#car_generator.map,
  NMap = maps:update(Pos,maps:get(Pos,Map)+1,Map),
  {noreply, State#car_generator{map = NMap}};
handle_cast(_Request, State) ->
  {noreply, State}.

handle_info({timeout, _Ref, loop}, State)  ->
  Map = State#car_generator.map,
  NMap = Map,
%%  NMap = generate(lists:filter(fun(X) -> maps:get(X,Map) > 0 end, maps:keys(Map)),State#car_generator.world_parameters,Map),
  erlang:start_timer(1000, self(), loop),
  {noreply, State#car_generator{map = NMap}};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.