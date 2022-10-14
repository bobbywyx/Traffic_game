classdef MyConst
   properties (Constant)
      % ----------user can change these----------
      
      FPS = 10;  % this is a fixed constant during the whole animation;
      WIDTH = 1; % there is actually no point to change the width of road, so I decided to make it a constant, integer is recommended
      
      AUTO_AVOID_CRASHING = true; 
      % When the lanes is quite large, cars crossing road cost a lot of time
      % and even if no one violates the traffic rules, there will still be some crashing, since cars at green want to cross
      % But if the AUTO_AVOID_CRASHING is true, cars crash are much harder to happen.
      % Those cars tries to run a red light will go ahead no matter what will happen.
      % Other cars will try to avoid crashing, so the only chance for a car to crash is
      % a car has already run a red light and crashes into a car coming from the vertical direction.

      RANDOM_CAR_LENTH = true;

      RANDOM_CAR_SPEED = true;
      FIXED_CAR_SPEED = 2; % if RANDOM_CAR_SPEED is false, this is the speed of all cars, otherwise this parameter is ignored
      
      RANDOM_CAR_COLOR = false; % if false, all cars are yellow or red
      CAR_COLOR_LIST = ['g', 'b', 'y', 'm', 'c']; 
      % the cars that will run red light are red, obviously and conveniently
      % so don't add 'r' in the CAR_COLOR_LIST
      
      ALLOW_TURN = false;

      % ----------not reccomended to change these down below, if you do change, bugs may occur----------
      CAR_LENGTH_LIST = [ 1.2 , 1.6 , 2 ]; 
      
      CAR_SPEED_LIST = [ 1.6 , 2 , 2.4];  % not interval but the fixed speed

      % ----------user change ends----------


      % ----------do not change these:----------
      
      % defalt values
      DEFAULT_CAR_NUMS = 30;
      DEFAULT_LANES = 3;
      DEFAULT_WIDTH = 1;
      DEFAULT_RUNLIGHT = 0.1;
      DEFAULT_R = 6;
      DEFAULT_G = 4;
      DEFAULT_Y = 2;
   end
end