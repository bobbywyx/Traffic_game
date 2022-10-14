classdef Car < handle
    %CAR 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        pos_x
        pos_y
        color
        length
        width
        plate
        id
        oritation
        on_moving = true;
        speed
        max_speed
        turning
        p_run_light
        did_run_light = false;
        want_run_light = false;
        next_car_obj
        prev_car_obj
        is_head
        is_end
        off_map = false;
        cross_road_obj
        cars_obj_list 
    end
    
    methods
        function obj = Car(pos_x,pos_y,length,plate,id,color,oritation,max_speed,p_run_light,is_head,is_end,cross_road_obj)
            %CAR 构造此类的实例
            %   此处显示详细说明
            obj.pos_x =pos_x;   
            obj.pos_y =pos_y;
            obj.color = color;
            obj.length = length;
            obj.width = 0.6;
            obj.plate = plate;
            % obj.plate = string(id);  % debug
            obj.id = id;
            obj.oritation = oritation;
            % obj.on_moving = false;
            obj.max_speed = max_speed;
            obj.speed = max_speed; % currently at max speed, this will be changed later
            obj.turning =  false;
            obj.p_run_light = p_run_light;
            obj.is_head = is_head;
            obj.is_end = is_end;
            % obj.off_map = false;
            obj.cross_road_obj = cross_road_obj;

            if rand < obj.p_run_light
                % this car will run light no matter what will happen
                obj.want_run_light = true;
                obj.color = 'r';
            end
        end
        
        function draw(obj)
            %draw 此处显示有关此方法的摘要
            %   此处显示详细说明
            obj.is_off_map();
            % draw body
            if ~obj.off_map
                switch obj.oritation
                    case {1,3}
                        % vertical
                        rectangle('Position',[obj.pos_x-obj.width/2 , obj.pos_y-obj.length/2 , obj.width,obj.length],'Linewidth',1,'LineStyle','-','FaceColor',obj.color);
                        % hold on;

                        % draw plate
                        text(obj.pos_x-obj.width/2,obj.pos_y,obj.plate,'FontSize',10);
                        % hold on;
                    case {2,4}
                        % horizontal
                        rectangle('Position',[obj.pos_x-obj.length/2 , obj.pos_y-obj.width/2 , obj.length,obj.width],'Linewidth',1,'LineStyle','-','FaceColor',obj.color);
                        % hold on;    
                        % draw plate
                        text(obj.pos_x-obj.length/2,obj.pos_y,obj.plate,'FontSize',10);
                        % hold on;
                end
            end
        end


        function move(obj)
            if obj.is_head
                % head car
                
                % debug
                obj.color = 'g';
                if obj.want_run_light
                    obj.color = 'm';
                end
            
                if MyConst.RANDOM_CAR_SPEED
                    % I admited that I should use enum at the very beginning, but now I am too lazy to change it
                    % this function do more work than it should do
                    obj.will_crash_next_move(0);
                end


                if obj.is_at_cross()
                    % head car at cross
                    obj.go_across_road();

                elseif obj.is_head
                    obj.on_moving = true;
                    obj.change_pos();
                end
            
            end
            if ~obj.is_head
                % cars following the head car
                head_car_obj = obj.get_head_car();
                
                % debug
                % disp(head_car_obj)
                
                
                if head_car_obj.on_moving
                    if obj.is_at_cross()
                        obj.go_across_road()

                    % elseif obj.on_moving
                    %     obj.change_pos();
                    else
                        obj.on_moving = true;
                        obj.change_pos();
                    end
                else
                    if MyConst.AUTO_AVOID_CRASHING
                        if obj.will_crash_next_move(0)
                            obj.on_moving = false;
                        end
                    else
                        obj.on_moving = false;
                    end
                end
                

            end
        end

        function go_across_road(obj)
            
            [lu,ru,rd,ld]=obj.cross_road_obj.get_light_status();
            traffic_light_status_list = [lu(1),ru(1),rd(1),ld(1)];
            switch traffic_light_status_list(obj.oritation)
                case 'r'
                    if obj.want_run_light && ~(obj.on_moving && obj.is_on_crossing())
                        obj.did_run_light = true;
                        obj.change_pos;
                    elseif obj.on_moving && obj.is_on_crossing()
                        % have to cross because you can't stop at the middle of the road
                        obj.change_pos();
                    else
                        obj.on_moving = false;
                        obj.stop();
                    end
                
                case 'y'
                    if obj.want_run_light && ~obj.is_on_crossing()
                        obj.change_pos();
                        obj.did_run_light = true;
                        obj.on_moving = true;
                    elseif obj.is_on_crossing()
                        % have to cross because you can't stop at the middle of the road
                        obj.change_pos();
                        obj.on_moving = true;
                    else
                        % if has not crossed then stop
                        obj.stop();
                    end
                    


                case 'g'
                    if obj.is_head
                        if ~obj.did_run_light
                            if MyConst.AUTO_AVOID_CRASHING
                                if obj.will_crash_next_move(0.1)
                                    obj.on_moving = false;
                                else
                                    obj.change_pos();
                                    obj.on_moving = true;
                                end
                            else
                                obj.on_moving = true;
                                obj.change_pos();
                            end
                        else
                            obj.on_moving = true;
                            obj.change_pos();
                        end
                    else
                        obj.change_pos();
                        obj.on_moving = true;
                    end

            end 
        end

        function stop(obj)
            % the car stoped itself and will become a head car
            if ~obj.is_head
                % The linked list will be cut
                obj.prev_car_obj.is_end = true;
                obj.prev_car_obj.next_car_obj = Car.empty;
                obj.prev_car_obj = Car.empty;
                obj.is_head = true;
            else

            end
            obj.on_moving = false;
            
        end

        function change_pos(obj)
            switch obj.oritation
            case 1
                obj.pos_y = obj.pos_y - obj.speed/MyConst.FPS;
            case 2
                obj.pos_x = obj.pos_x - obj.speed/MyConst.FPS;
            case 3
                obj.pos_y = obj.pos_y + obj.speed/MyConst.FPS;
            case 4
                obj.pos_x = obj.pos_x + obj.speed/MyConst.FPS;
            end

        end


        function output = is_at_cross(obj)
            output = false;
            dis_to_c = obj.cross_road_obj.WxL +obj.length/2+0.1;
            dis_after_c = obj.cross_road_obj.WxL - (obj.length/2+0.1);
            switch obj.oritation
            case 1
                if obj.pos_y < obj.cross_road_obj.center_y+ dis_to_c && obj.pos_y >= obj.cross_road_obj.center_y - dis_after_c
                    output = true;
                end
            case 2
                if obj.pos_x < obj.cross_road_obj.center_x+ dis_to_c && obj.pos_x >= obj.cross_road_obj.center_x - dis_after_c
                    output = true;
                end
            case 3
                if obj.pos_y > obj.cross_road_obj.center_y- dis_to_c && obj.pos_y <= obj.cross_road_obj.center_y + dis_after_c
                    output = true;
                end
            case 4
                if obj.pos_x > obj.cross_road_obj.center_x- dis_to_c && obj.pos_x <= obj.cross_road_obj.center_x + dis_after_c
                    output = true;
                end
            end

            %debug
            %{
            if output
                obj.plate = 'AT';
            end
            %}
        end

        function output = is_on_crossing(obj)
            output = false;
            dis_to_c = obj.cross_road_obj.WxL+obj.length/2-0.2;
            dis_after_c = obj.cross_road_obj.WxL - (obj.length/2+0.1);
            switch obj.oritation
            case 1
                if obj.pos_y <= obj.cross_road_obj.center_y+ dis_to_c && obj.pos_y >= obj.cross_road_obj.center_y - dis_after_c
                    output = true;
                end
            case 2
                if obj.pos_x <= obj.cross_road_obj.center_x+ dis_to_c && obj.pos_x >= obj.cross_road_obj.center_x - dis_after_c
                    output = true;
                end
            case 3
                if obj.pos_y >= obj.cross_road_obj.center_y- dis_to_c && obj.pos_y <= obj.cross_road_obj.center_y + dis_after_c
                    output = true;
                end
            case 4
                if obj.pos_x >= obj.cross_road_obj.center_x- dis_to_c && obj.pos_x <= obj.cross_road_obj.center_x + dis_after_c
                    output = true;
                end
            end
            % debug
            %{
            if output
                obj.plate = 'On';
            end
            %}
        end

        function crashed = will_crash_next_move(obj,allowed_distance)        
            crashed = false;
    
            % fake move
            switch obj.oritation
            case 1
                tmp_y = obj.pos_y - obj.speed/MyConst.FPS;
                tmp_x = obj.pos_x;
            case 2
                tmp_x = obj.pos_x - obj.speed/MyConst.FPS;
                tmp_y = obj.pos_y;
            case 3
                tmp_y = obj.pos_y + obj.speed/MyConst.FPS;
                tmp_x = obj.pos_x;
            case 4
                tmp_x = obj.pos_x + obj.speed/MyConst.FPS;
                tmp_y = obj.pos_y;
            end

            % check if the car will crash with another car
            % since the car may change oritation, so we need to check all the cars
            car1= obj;
            for i = length(obj.cars_obj_list):-1:1
                car2 = obj.cars_obj_list(i);
                if car1.id == car2.id
                    continue;
                end

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
                
                if car2.on_moving
                    % if car 2 is also moving, we need to check the next move
                    % fake move of car 2
                    switch car2.oritation
                    case 1
                        tmp2_y = car2.pos_y - car2.speed/MyConst.FPS;
                        tmp2_x = car2.pos_x;
                    case 2
                        tmp2_x = car2.pos_x - car2.speed/MyConst.FPS;
                        tmp2_y = car2.pos_y;
                    case 3
                        tmp2_y = car2.pos_y + car2.speed/MyConst.FPS;
                        tmp2_x = car2.pos_x;
                    case 4
                        tmp2_x = car2.pos_x + car2.speed/MyConst.FPS;
                        tmp2_y = car2.pos_y;
                    end
                else
                    tmp2_x = car2.pos_x;
                    tmp2_y = car2.pos_y;
                end

                dis_x = abs(tmp_x - tmp2_x);
                dis_y = abs(tmp_y - tmp2_y);

                if dis_x<=min_dis_x + allowed_distance && dis_y <= min_dis_y + allowed_distance
                    if car1.is_head && car2.oritation == car1.oritation && obj.is_following_another_car(car2)
                        % if the two cars are in the same oritation, then the cars will be merged in to a new linked list

                        % debug
                        % disp('merge  '+string(car1.plate)+'   '+string(car2.plate));
                        % if ~MyConst.RANDOM_CAR_COLOR
                        %     car1.color = 'y';
                        % end

                        % car1 ---> car2
                        car2.is_end = false;
                        car1.is_head = false;
                        car2.next_car_obj = car1;
                        car1.prev_car_obj = car2;
                        obj.on_moving = false;

                        car1.speed = car2.speed;
                        tmp_car = car1;
                        % make all the cars behind keep the same speed
                        while ~tmp_car.is_end
                            tmp_car = tmp_car.next_car_obj;
                            tmp_car.on_moving = false;
                            tmp_car.speed = car2.speed;
                        end
                        
                    else
                        crashed = true;
                    end
                    % debug
                    % disp(string(car1.plate));
                    % disp('will crash with' + string(car2.plate));
                    % disp('car1 pos: ' + string(car1.pos_x) + ' ' + string(car1.pos_y));
                    % disp('car2 pos: ' + string(car2.pos_x) + ' ' + string(car2.pos_y));
                    % disp('dis_x' + string(dis_x));
                    % disp('dis_y' + string(dis_y));
                    % disp('min_dis_x' + string(min_dis_x));
                    % disp('min_dis_y' + string(min_dis_y));
                end
            end
        end
        
        function output = is_following_another_car(obj,car2)            
            output = false;
            switch obj.oritation
            case 1
                if obj.pos_y>car2.pos_y
                    output = true;
                end
            case 2
                if obj.pos_x>car2.pos_x
                    output = true;
                end
            case 3
                if obj.pos_y<car2.pos_y
                    output = true;
                end
            case 4
                if obj.pos_x<car2.pos_x
                    output = true;
                end
            end
            % if obj.max_speed<car2.speed && car2.on_moving
            %     output = false;
            % end

            % debug
            % if output
            %     disp('is following' + string(car2.plate));
            % else
            %     disp('is not following' + string(car2.plate));
            % end


        end

        function output = is_off_map(obj)
            cro = obj.cross_road_obj;
            switch obj.oritation
            case 1
                if obj.pos_y <= cro.center_y - cro.length
                    obj.off_map = true;
                    output = true;
                end
            case 2
                if obj.pos_x <= cro.center_x - cro.length
                    obj.off_map = true;
                    output = true;
                end
            case 3
                if obj.pos_y >= cro.center_y + cro.length 
                    obj.off_map = true;
                    output = true;
                end
            case 4
                if obj.pos_x >= cro.center_x + cro.length
                    obj.off_map = true;
                    output = true;
                end
            end
        end

        function car_obj = get_head_car(obj)
            car_obj = obj;
            while ~car_obj.is_head
                car_obj = car_obj.prev_car_obj;
            end
        end
        
    end
end
