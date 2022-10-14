classdef CrossRoad < handle
    %CROSSROAD 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        width;
        length;
        oritation;
        center_x;
        center_y;
        r_time;
        g_time;
        o_time;
        lanes;
        % the internal time stamp is decided by crossroad
        time = 0;
        
        % first digit fot left up corner, and red light first
        % second digit for right up corner
        % red --> green -->  orange --> red ....
        traffic_light_status = [0 0];
        period;
        WxL; % real width of the L shape
    end
    
    methods
        function obj = CrossRoad(width,length,lanes,center_x,center_y,r_time,g_time,o_time)
            %CROSSROAD 构造此类的实例
            %   width:
            %   lanes
            %   length is the length of lines

            obj.width = width;
            obj.length = length;
            obj.lanes = lanes;
            obj.center_x = center_x;
            obj.center_y = center_y;
            obj.r_time = r_time;
            obj.g_time = g_time;
            obj.o_time = o_time;
            obj.period = r_time+g_time+o_time;
            obj.WxL = lanes*width;
        end
        
        function [lu,ru,rd,ld]=get_light_status(obj)
            % lu --> left up corner    ru --> right up corner  ld --> left down   rd --> right down
            % 0 -> red  1 --> green   2--->orange
            
            i = mod(obj.time,obj.period);

            if i<obj.r_time
                lu = 'red';
                rd = 'red';
            elseif i<obj.r_time + obj.g_time
                lu = 'green';
                rd = 'green';
            else
                % note that there is no color called orange in matlab so I have to use yellow
                lu = 'yellow';
                rd = 'yellow';
            end

            
            if i < obj.g_time
                ru = 'green';
                ld = 'green';
            elseif i< obj.g_time + obj.o_time
                ru = 'yellow';
                ld = 'yellow';
            else
                ru = 'red';
                ld = 'red';
            end
            % 特此解释，本来不想要面向字符串编程的，奈何判断实在是麻烦，以及matlab没有自带枚举，也懒得自己写了，干脆摆烂面向字符串编程

        end

        function  draw(obj)
            %METHOD1 This function should be called by Class draw
            %   prepare all the things need to be draw

                % Draw the L shape first
                %                             __      __            
                %   oritation:  0--> L   1-->|    2-->  |   3--> _|


                % default oritation=0, convert later
                % horizontal line y value

                h_line_y = obj.center_y + obj.WxL;
                h_line_start_x = obj.center_x + obj.WxL;
                plot([ h_line_start_x , h_line_start_x + obj.length ], [ h_line_y , h_line_y ],'-b'); 
                % hold on;
                %vertical line x value
                v_line_x = obj.center_x + obj.WxL;
                v_line_start_y = obj.center_y + obj.WxL;
                plot([ v_line_x , v_line_x ], [ v_line_start_y , v_line_start_y + obj.length ],'-b'); 
                % hold on;

                %      __
                % 1-->|  
                h_line_y = 2*obj.center_y - h_line_y;
                plot([ h_line_start_x , h_line_start_x + obj.length ], [ h_line_y , h_line_y ],'-b'); 
                % hold on;
                %vertical line
                v_line_start_y = obj.center_y - obj.WxL;
                plot([ v_line_x , v_line_x ], [ v_line_start_y - obj.length, v_line_start_y],'-b'); 
                % hold on;

                %      __  
                % 2 -->  |
                h_line_start_x = 2 * obj.center_x - h_line_start_x;
                plot([ h_line_start_x - obj.length, h_line_start_x ], [ h_line_y , h_line_y ],'-b'); 
                % hold on;
                %vertical line
                v_line_x =2* obj.center_x - v_line_x;
                plot([ v_line_x , v_line_x ], [ v_line_start_y - obj.length , v_line_start_y ],'-b'); 
                % hold on;

                % 3 --> __|
                h_line_y = 2* obj.center_y - h_line_y;
                plot([ h_line_start_x - obj.length, h_line_start_x ], [ h_line_y , h_line_y ],'-b'); 
                % hold on;
                %vertical line
                v_line_start_y = 2 * obj.center_y - v_line_start_y;
                plot([ v_line_x , v_line_x ], [ v_line_start_y , v_line_start_y + obj.length ],'-b'); 
                % hold on;

                % Draw the parting line
                % up
                plot([ obj.center_x, obj.center_x ], [ obj.center_y + obj.WxL , obj.center_y + obj.WxL + obj.length ],':b'); 
                % hold on;
                % right
                plot([ obj.center_x + obj.WxL , obj.center_x + obj.WxL + obj.length ], [ obj.center_y , obj.center_y ],':b'); 
                % hold on;
                % down
                plot([ obj.center_x, obj.center_x ], [ obj.center_y - obj.WxL , obj.center_y - obj.WxL - obj.length ],':b'); 
                % hold on;
                % left
                plot([ obj.center_x - obj.WxL , obj.center_x - obj.WxL - obj.length ], [ obj.center_y , obj.center_y ],':b'); 
                % hold on;


                % Draw lights
                [lu,ru,rd,ld]=obj.get_light_status();
                scatter(obj.center_x - obj.WxL ,obj.center_y + obj.WxL,lu,'filled'); % left up
                % hold on;
                scatter(obj.center_x + obj.WxL ,obj.center_y + obj.WxL,ru,'filled'); % right up 
                % hold on;
                scatter(obj.center_x - obj.WxL ,obj.center_y - obj.WxL,ld,'filled'); % left down
                % hold on;
                scatter(obj.center_x + obj.WxL ,obj.center_y - obj.WxL,rd,'filled'); % right down
                % hold on;
        end

    end
end
