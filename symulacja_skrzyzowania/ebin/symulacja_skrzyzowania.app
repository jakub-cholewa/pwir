{ application, symulacja_skrzyzowania,
 [ { description, "Crossroad simulation in Erlang with Cars." },
   { vsn, "1.0" },
   { modules, [ basic_actions,	cars_generator, main_supervisor, simulations_supervisor, controller] },
   { registered, [] },
   { applications, [ kernel, stdlib, sasl ] },
   { env, [] },
   { mod, { simulation, [] } }
 ]
}.
