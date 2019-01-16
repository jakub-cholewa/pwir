{ application, symulacja_skrzyzowania,
 [ { description, "Crossroad simulation in Erlang with Cars." },
   { vsn, "1.0" },
   { modules, [ main_supervisor, simulation_supervisor, simulation, controller, event_stream, basic_actions, cars_generator] },
   { registered, [] },
   { applications, [ kernel, stdlib, sasl ] },
   { env, [] },
   { mod, { simulation, [] } }
 ]
}.
