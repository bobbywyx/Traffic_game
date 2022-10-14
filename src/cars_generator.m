function cars_list = cars_generator(lane_cars_list,p,n,cross_road_obj)
    % 
    % The order or id of roads are like
    %     1 2  | 9  10 
    % 16       |        3
    % 15       |        4
    %   -------+--------
    % 8        |        11
    % 7        |        12
    %    14 13 |  6 5
    %


    plates = plate_generation(n);
    
    id = 1;

    % debug
    % disp(lane_cars_list)
    % disp(plates);

    for i = 1:length(lane_cars_list)
        for j = 1:lane_cars_list(i)
            if MyConst.RANDOM_CAR_LENTH
                car_length = MyConst.CAR_LENGTH_LIST(randi([1 3]));
            else
                car_length = 1.6;
            end
            
            switch floor((i-1)/(length(lane_cars_list)/4))+1
            case 1 %left up

                lanes_from_center = mod(i-1,length(lane_cars_list)/4); % 0,1,2,3
                car_x = cross_road_obj.center_x - 0.5 * cross_road_obj.width - lanes_from_center * cross_road_obj.width ;
                if j==1
                    car_y = cross_road_obj.center_y + cross_road_obj.width + cross_road_obj.length + (j*2-1) * (0.2+car_length)/2;
                else
                    car_y = car_y + (0.2+car_length + cars_list(id-1).length)/2;
                end

                % scatter(car_x,car_y);
                % hold on;
                oritation = 1;
            case 2 %rigth up
                lanes_from_center = mod(i-1,length(lane_cars_list)/4);

                if j ==1
                    car_x = cross_road_obj.center_x + cross_road_obj.width + cross_road_obj.length + (j*2-1) * (0.2+car_length)/2;
                else
                    car_x = car_x + (0.2+car_length + cars_list(id-1).length)/2;
                end
                
                car_y = cross_road_obj.center_y + 0.5 * cross_road_obj.width + lanes_from_center * cross_road_obj.width ;
                % scatter(car_x,car_y);
                % hold on;
                oritation = 2;
            case 3
                lanes_from_center = mod(i-1,length(lane_cars_list)/4);

                car_x = cross_road_obj.center_x + 0.5 * cross_road_obj.width + lanes_from_center * cross_road_obj.width ;

                if j==1
                    car_y = cross_road_obj.center_y - cross_road_obj.width - cross_road_obj.length - (j*2-1) * (0.2+car_length)/2;
                else
                    car_y = car_y - (0.2+car_length + cars_list(id-1).length)/2;
                end
                
                    % scatter(car_x,car_y);
                % hold on;
                oritation = 3;
            case 4
                lanes_from_center = mod(i-1,length(lane_cars_list)/4);

                if j==1
                    car_x = cross_road_obj.center_x - cross_road_obj.width - cross_road_obj.length - (j*2-1) * (0.2+car_length)/2;
                else
                    car_x = car_x - (0.2+car_length + cars_list(id-1).length)/2;
                end                
                
                car_y = cross_road_obj.center_y - 0.5 * cross_road_obj.width - lanes_from_center * cross_road_obj.width ;
                % scatter(car_x,car_y);
                % hold on;
                oritation = 4;
            end


            % head or end judge
            is_head = false;
            is_end = false;
            if j ==1
                % the first car of the lane
                is_head = true;
            end
            if j == lane_cars_list(i)
                % the last car of the lane
                is_end = true;
            end

            % color
            if MyConst.RANDOM_CAR_COLOR
                color = MyConst.CAR_COLOR_LIST(randi([1,length(MyConst.CAR_COLOR_LIST)]));
            else
                color = 'y';
            end

            % speed
            if MyConst.RANDOM_CAR_SPEED
                max_speed = MyConst.CAR_SPEED_LIST(randi([1,length(MyConst.CAR_SPEED_LIST)]));
            else
                max_speed = MyConst.FIXED_CAR_SPEED;
            end

            car_obj = Car(car_x,car_y,car_length , plates(id,:), id,color ,oritation, max_speed , p , is_head,is_end,cross_road_obj);
            % disp(car_x);
            % disp(car_y);
            cars_list(id) = car_obj;
            % disp(car_obj)
            id = id+1;
        end

    end



    % link list
    if MyConst.RANDOM_CAR_SPEED
        for id = 1:length(cars_list)
            if ~cars_list(id).is_head
                if cars_list(id).max_speed < cars_list(id-1).speed
                    cars_list(id).is_head = true;
                    cars_list(id-1).is_end = true;
                elseif cars_list(id).max_speed >= cars_list(id-1).speed
                    cars_list(id).speed = cars_list(id-1).speed;
                    cars_list(id).is_head = false;
                    cars_list(id-1).is_end = false;
                    cars_list(id).prev_car_obj = cars_list(id-1);
                    cars_list(id-1).next_car_obj = cars_list(id);
                else
                    cars_list(id).prev_car_obj = cars_list(id-1);
                end

            end
        end
    else

        for id=1:length(cars_list)
            if ~cars_list(id).is_head
                cars_list(id).prev_car_obj = cars_list(id-1);
            end
            if ~cars_list(id).is_end
                cars_list(id).next_car_obj = cars_list(id+1);
            end
        end
    end
end