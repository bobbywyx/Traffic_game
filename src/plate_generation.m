function plates = plate_generation(n)
    elements = ['A';'B';'C';'D';'1';'2';'3';'4';'5';'6';'7';'8';'9';'0'];
    % e = ['1';'2';'3'];
    % n is how many plates you want

    % init
    plate = [];
    for i=1:n
        plate = [plate;''];
    end

    % generate a str of 5 letters at one time is unnecessary
    str1 = random_str(elements,3);
    len1 =  length(str1); 

    % the probability that same plates occur is very low, skip the check for now
    for i=1:n
        plates(i,:) = [elements(floor(rand*4)+1),' ',str1(floor(rand*len1)+1 , : ),str1(floor(rand*len1)+1 ,1:2)];
    end
end

% recursive function, abandoned now for low efficiency
function str_list = random_str(elements,len)
    str_list = [];

    if len>1
        base_list = random_str(elements,len-1);
        for i = 1:length(base_list)
            for j = 1:length(elements)
                str = [base_list(i,:),elements(j)];
                str_list = [str_list;str];
            end
        end
    else
        for i=1:length(elements)
            str_list = [str_list;elements(i)];
        end
    end
    
end