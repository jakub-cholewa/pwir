-module(simulation_cars_supervisor).

-behaviour(gen_server).

-include("records.hrl").


%% API
-export([start_link/1, init/1, handle_call/3,
  handle_cast/2, handle_info/2, terminate/2,
  code_change/3, kill_children/0]).


start_link([WorldParameters]) ->
  [P1,P2,P3,P4] = simulation_defaults:get_start_points(car, WorldParameters),
  gen_server:start_link({local, ?MODULE}, ?MODULE, #car_generator{map = #{P1 => 0, P2 => 0, P3 => 0, P4 => 0}, world_parameters = WorldParameters}, []).

kill_children() ->
  simulation_defaults:stop_children(?MODULE).



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
  NMap = generate(lists:filter(fun(X) -> maps:get(X,Map) > 0 end, maps:keys(Map)),State#car_generator.world_parameters,Map),
  erlang:start_timer(1000, self(), loop),
  {noreply, State#car_generator{map = NMap}};
handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


generate([],_WorldParameters,NState) -> NState;
generate([Pos|T],WorldParameters,NState) ->
  Cars = supervisor:which_children(simulation_traffic_supervisor),
  case simulation_defaults:ask_cars_for_position(Cars,Pos#position.x,Pos#position.y,self()) of
    free ->
      Dest = simulation_defaults:random_direction(),
      UUID = gen_server:call(uuid_provider,next_car),
      Car = { {car, UUID},
        {car_entity, start_link, [{WorldParameters,{Pos,Dest}}]},
        temporary, brutal_kill, worker,
        [ car_entity ]},
      supervisor:start_child(simulation_traffic_supervisor, Car),
      generate(T,WorldParameters,maps:update(Pos,maps:get(Pos,NState)-1,NState));
    _ ->
      generate(T,WorldParameters,NState)
  end.