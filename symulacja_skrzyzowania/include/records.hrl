-author("molion").

-record(position, {x, y, direction_x, direction_y}).
-record(world_parameters, {cars_start_amount}).
-record(car, {pid, direction, position = #position{}, world_parameters = #world_parameters{}, timer, car_moves}).
-record(car_generator, {map ={}, world_parameters = #world_parameters{}}).