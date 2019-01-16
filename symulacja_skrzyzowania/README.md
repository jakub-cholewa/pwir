Build and run:
1. Install rebar3 from https://github.com/erlang/rebar3 in symulacja_skrzyzowania
2. ./rebar3 compile
3. erl -pa _build/default/lib/symulacja_skrzyzowania/ebin

Start simulation:
- application:start(sasl).
- application:start(symulacja_skrzyzowania).
- controller:start_simulation().


