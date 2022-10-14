function [n,w,l,p,g,o,r,lane_cars_list] = initialize()
    % initialize input parameters by user
    w = MyConst.WIDTH;
    
    prompt = input("\n press enter to start \n if you want to use the default value, please input 'd', or 'a' for assist generation \n ",'s');
    

    if prompt == 'd'
        n = MyConst.DEFAULT_CAR_NUMS;
        l = MyConst.DEFAULT_LANES;
        w= MyConst.DEFAULT_WIDTH;
        p = MyConst.DEFAULT_RUNLIGHT;
        r = MyConst.DEFAULT_R;
        g = MyConst.DEFAULT_G;
        o = MyConst.DEFAULT_Y;
        lane_cars_list =  random_cars_generator(n,l);
    elseif prompt == 'a'
        disp('assistance not supported yet');
    else
        valid_flag = false;
        while ~valid_flag
            n = input("\nPlease input the total numbers of cars   \n(integer)\n");
            % w = input("\nPlease input the width of the road \nThe length unit of each lane(1 is preferred)   \n(integer)");
            % l= 1;  % lanes
            l = input("\nPlease input the number of lanes of the road \n Above 3 is strongly NOT recommended   \n(integer)");
            p = input("\nPlease input the probability that a cars does not stop at the redlight  \n(float between 0 and 1)");
            r = input("\n \n ---Note that r should equals to the sum of g and o---- \n \nPlease input the time redlight will last   \n(integer)");
            g = input("\nPlease input the time greenlight will last  \n(integer)"); 
            o = input("\nPlease input the time orangelight will last \n(integer)");

            if n<=0 || w<=0 || l<1 || p>1 || p<0 || g<0 || o <0 || r<0
                disp()
                disp("--------------------Input error, please try again--------------------") 
            else

                disp("simulation will start in a minute");
                lane_cars_list =  random_cars_generator(n,l);
                valid_flag = true;
            end
        end
    end
end


function lane_cars_list = random_cars_generator(n,l)
    % generates cars on each road randomly
    % only an array of nums of cars is returned

    is_success = false;
    while ~is_success
        randomlist = rand(1,l*4);
        sum_rand = sum(randomlist);
        lane_cars_list = round(randomlist/sum_rand*n);
        % the sum should be equal, or the process will start from begining
        if sum(lane_cars_list) == n
            is_success = true;
        end
    end
end
