-record(position,{x,y,look_x,look_y}).
-record(world_parameters, {light_time, yellow_light_time, car_number, cars_start_amount}).
-record(car, {pid, destination, position = #position{}, world_parameters = #world_parameters{}, timer_ref, making_move}).
-record(car_generator,{map = #{}, world_parameters = #world_parameters{}}).