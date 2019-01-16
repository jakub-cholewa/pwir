-module(controller).

-behavior(gen_server).

-include("../include/records.hrl").


%% API
-export([start_link/1, start_simulation/0, stop_simulation/0, generate_cars/1]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).


start_link(WorldParameters) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, WorldParameters, []).

start_simulation() ->
  gen_server:call(?MODULE, start_simulation).

stop_simulation() ->
  gen_server:call(?MODULE, stop_simulation).

generate_cars(Amount) ->
  gen_server:call(?MODULE, {generate_cars,Amount}).


init(WorldParameters) ->
  {ok, {stopped,WorldParameters}}.

handle_call(start_simulation, _From, {stopped,WorldParameters}) ->
  main_supervisor:start_simulation(WorldParameters),
  {reply, started, {started,WorldParameters}};

handle_call(start_simulation, _From, {started,WorldParameters}) ->
  {reply, already_started, {started,WorldParameters}};

handle_call(stop_simulation, _From, {started,WorldParameters}) ->
  main_supervisor:stop_simulation(),
  {reply, stopped, {stopped,WorldParameters}};

handle_call(stop_simulation, _From, {stopped,WorldParameters}) ->
  {reply, already_stopped, {stopped,WorldParameters}};

handle_call({generate_cars, Amount}, _From, {started,WorldParameters}) ->
  main_supervisor:generate_cars(WorldParameters,Amount),
  {reply, cars_generated, {started,WorldParameters}};

handle_call({generate_cars, _Amount}, _From, {stopped,WorldParameters}) ->
  {reply, cars_not_generated, {stopped,WorldParameters}}.

handle_cast(start_socket_handler, State) ->
  main_supervisor:add_socket_handler(),
  {noreply, State};
handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
