% initialization
[n,w,l,p,g,o,r,lane_cars_list] =  initialize();
%{ 
n: car numbers
w: road width
l: road lanes
p: possibility no stop at red
g: greenlight time
o: orangelight time
r: redlight time
lane_cars_list: cars on each lane, lanes are numbered in clockwise direction, start at top
%}


time = 0;

% Now that only one cross road is present, only one object created.
cross_road1 = CrossRoad(w,w*10,l,0,0,r,g,o);
cars_obj_list = cars_generator(lane_cars_list,p,n,cross_road1);

for i = 1:n
    cars_obj_list(i).cars_obj_list = cars_obj_list;

    % have no choice but to do this, since global is not allowed, or one single car can't easily have access to another car
    % I did designed linked list but it will not work when cars turn right or left.
end


figure(1);

% start main loop
crash_flag = false;
finished = false;


while (~ crash_flag) && (~ finished)
    % It seems that the program runs slow, no need to pause
    % pause(1/MyConst.FPS);

    for i = 1:n
        cars_obj_list(i).move();
    end

    drawer(cross_road1,cars_obj_list);
    
    cross_road1.time = cross_road1.time+1/MyConst.FPS;
    time = time+1/MyConst.FPS;
    [crash_flag,finished] = is_crashed_or_finish(cars_obj_list);
end

% game end
if crash_flag
    msgbox('Crash happens and gameover. Go back to command window to see the result','Game Over');
else
    msgbox('Good job, everyone is safe and sound','Game Over');
end

display_runlight(cars_obj_list);



function [crashed,finished] = is_crashed_or_finish(cars_obj_list)
    finished = true;
    crashed = false;
    if length(cars_obj_list)>1
        % if there is only one car then no crush will ever happen
        for i = 1:length(cars_obj_list)
            if ~cars_obj_list(i).off_map
                finished = false;
            end
            for j = i+1:length(cars_obj_list) 
                % car1 - car2 and car2 - car1 is equivalent 
                car1 = cars_obj_list(i);
                car2 = cars_obj_list(j);
                % the actual distance
                dis_x = abs(car1.pos_x - car2.pos_x);
                dis_y = abs(car1.pos_y - car2.pos_y);
            
                % the min distance before crash
                min_dis_x = 0;
                min_dis_y = 0;
                switch car1.oritation
                    case {1,3}
                        % vertical
                        min_dis_x = min_dis_x + car1.width/2;
                        min_dis_y = min_dis_y + car1.length/2;
                    case {2,4}
                        min_dis_x = min_dis_x + car1.length/2;
                        min_dis_y = min_dis_y + car1.width/2;
                end
                switch car2.oritation
                    case {1,3}
                        min_dis_x = min_dis_x + car2.width/2;
                        min_dis_y = min_dis_y + car2.length/2;
                    case {2,4}
                        min_dis_x = min_dis_x + car2.length/2;
                        min_dis_y = min_dis_y + car2.width/2;
                end
                if dis_x<min_dis_x && dis_y < min_dis_y
                    crashed = true;
                end
            end
        end
    else
        % only one car
        if ~cars_obj_list(1).off_map
            finished = false;
        end
    end
    % output = output || finished;
end 

function display_runlight(cars_obj_list)
    % display cars that run light
    exist_run_light = false;
    for i = 1:length(cars_obj_list)
        if cars_obj_list(i).did_run_light
            if ~exist_run_light
                disp('These cars did run red light')
                exist_run_light = true;
            end
            disp(cars_obj_list(i).plate);
        end
    end
end

