# Cross road traffic game

## About this project

This project is to simulate a cross road and test what may happen if some drivers don't obey traffic rules.

## Dependency

Running with MATLAB R2022a, no tool box needed

## Quick start

Run the file main.m in Matlab

There are three modes:

---

+ 1: defalut mode
+ The parameters are set in the file `MyConst.m`

---

+ 2: user input
+ Input `n`, the total number of cars, `l` the lanes of the road, and `p` the probability that a cars does not stop at the red light;
+ The number of cars on each line is randomly decided with respect to `n`;
+ The color cycle of a traffic light is green for `g` s, orange for `o` s, and red for `r` s; Sets the value of the variables `g`, `o`, and `r`;

---

+ 3: user input with support
+ Not supported yet lol

---

## More about the simulation

Once a car crash happens, the program will stop. In real world the problem is very complicated so if the simulation shows something weird, sorry but I tried my best to imporve the logic.

## Advance

There are some intersting options provided in the `MyConst.m`, like `FPS` `AUTO_AVOID_CRASHING` `RANDOM_CAR_SPEED` and so on.

## About project

This project, is for fun and please don't take it serious. Thanks for supporting.
