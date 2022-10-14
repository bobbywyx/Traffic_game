function drawer(cross_road_obj,cars_obj_list)
    % draw the objects given
    clf;
    hold on;
    cross_road_obj.draw();
    for i = 1:length(cars_obj_list)
        cars_obj_list(i).draw();
    end
    % hold off;
    daspect([1 1 1]);
    % axis equal;
    axis off;
    drawnow;

end

