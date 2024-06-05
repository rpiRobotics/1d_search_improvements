# 1D Search Improvements
![image](https://github.com/rpiRobotics/1d_search_improvements/assets/4022499/75dfaaf5-e26f-4319-9e3f-493f75fb8430)

| Revision | Note                                                 | % Correct | Time (us) |
|----------|------------------------------------------------------|-----------|-----------|
| 0        |                                                      | 89        | 1235.55   |
| 1        | Search over 2/4 branches                             | 89        | 800.56    |
| 2        | LS solns, increase cross thresh, decrease search tol | 99.8      | 1158.93   |
| 3        | Cut intial samples from 1e3 to 500                   | 99.8      | 656.318   |
| 3*       | * Increase test cases from 1,000 to 10,000           | 99.78     | 735.829   |
| 4        | Simplify zero cross detection code, fix NaN branches | 99.78     | 715.402   |
| 5        | Find local min / max for each triangle pointing to 0 | 100       | 754.681   |
| 5*       | * Increase test cases from 10,000 to 100,000         | 99.999    | 791.278   |
| 6        | Decrease samples from 500 to 250 (10,000 test cases) | 100       | 497.381   |



## Goal
100% empirical success rate in finding all solutions for Motoman SIA50D parameterized by SEW angle in a realistic workspace at > 100 Hz
(Shoulder at joint 2)

![SIA50_500](https://github.com/rpiRobotics/1d_search_improvements/assets/4022499/2b1dc019-30fb-4449-8662-96f6a99b515b)

## Problem
Current C++ implementation of IK for Motoman SIA50D is too slow / misses too many solutions

## Plan
1. Determine benchmark parameters
  * Workspace (Some sphere?)
  * Number of testing points (1000?)
  * Computer to use (CPU speed)
  * Testing procedure (will use MATLAB)
2. Benchmark current performance
3. Apply improvement strategies and measure performance difference
4. Repeat until 100% success at 10 ms
5. Apply changes to C++ implementation

## Computation time milestones
 * 20 Hz,  50 ms – GUI display 
 * 100 Hz, 10 ms – Mid-range control loop
 * 500 Hz,  2 ms – Realtime control loop (stretch goal)

## Strategies to try to improve 1D search performance
 * Utilize robot symmetry (only need half of error branches)
 *  Use multiple unique error functions
 * Hard-code kinematic parameters into code
   *  Or hardcode error function with tan⁡(𝜃/2)
 *  Use intelligent global optimization algorithms (not uniform sampling)
 *  Search not just for zeros but also for minima / maxima
 *  Search for endpoints
     *  Or use least-squares branches
     *  Or find endpoints analytically 
