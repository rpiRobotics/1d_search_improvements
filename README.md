# 1D Search Improvements
Improving the 1D search algorithm in [IK-Geo](https://github.com/rpiRobotics/ik-geo) to achieve high precision and success rate. Testing is performed on the Motoman SIA50D 7-DOF robot arm parameterized by conventional SEW angle with shoulder placed on joint 2.

## Problem formulation
The goal was to achieve 100% empirical success rate over 10,000 random test cases (random joint angles) while minimizing execution time based on the following milestones:
 * 20 Hz,  50 ms – GUI display 
 * 100 Hz, 10 ms – Mid-range control loop
 * 500 Hz,  2 ms – Real-time control loop (stretch goal)

Testing was performed using MATLAB MEX on a computer running Windows 10 on an Intel Core i7-3770K CPU at 3.50 GHz and 16 GB memory.


## Results

With just a few improvements, 1D search performance was significantly improved.  Success rate went from 89% to 100%, and computation time was better than the fastest milestone.

 | ![image](https://github.com/rpiRobotics/1d_search_improvements/assets/4022499/75dfaaf5-e26f-4319-9e3f-493f75fb8430) | ![SIA50_500](https://github.com/rpiRobotics/1d_search_improvements/assets/4022499/2b1dc019-30fb-4449-8662-96f6a99b515b) |
|-|-|

| Revision | Note                                                 | % Correct | Time (us) |
|----------|------------------------------------------------------|-----------|-----------|
| 0        |                                                      | 89        | 1235.55   |
| 1        | Search over 2/4 branches                             | 89        | 800.56    |
| 2        | LS solns, increase cross thresh, decrease search tol | 99.8      | 1158.93   |
| 3        | Cut initial samples from 1e3 to 500                  | 99.8      | 656.318   |
| 3*       | * Increase test cases from 1,000 to 10,000           | 99.78     | 735.829   |
| 4        | Simplify zero cross detection code, fix NaN branches | 99.78     | 715.402   |
| 5        | Find local min / max for each triangle pointing to 0 | 100       | 754.681   |
| 5*       | * Increase test cases from 10,000 to 100,000         | 99.999    | 791.278   |
| 6        | Decrease samples from 500 to 250 (10,000 test cases) | 100       | 497.381   |


The following improvements were made:
 * Search over only 2 of 4 error function branches. Due to robot symmetry, the four error function branches come in two identical pairs.
 * Use least-squares solutions. This guarantees the error function is always defined, meaning the bracketing method does not fail near endpoints.
 * Search not just for zeros but also for minima / maxima. This improves performance near robot singularities where the error function touches but only barely passes zero. 

## Future work
There are still a number of strategies that may improve 1D search performance even further:
 *  Use multiple unique error functions
 * Hard-code kinematic parameters into code
   *  Or hard code error function with tan⁡(𝜃/2)
 *  Use intelligent global optimization algorithms (not uniform sampling)
 *  Search for endpoints
     *  Or find endpoints analytically 
