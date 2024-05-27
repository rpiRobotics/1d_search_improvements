function [T_avg, Q_testing] = timing_inner(P_list)
ik_fun = @ik_mm50_rev3;
%N = 10e3;
N=1000;
% Q_testing = NaN(7,16, N);
Q_testing = NaN(7,64, N);

ex = [1;0;0];
ey = [0;1;0];
ez = [0;0;1];
zv = zeros(3,1);
SEW = sew_conv(rot(ey,-pi/4)*ez);
kin = hardcoded_IK_setup_MM50_SJ2.get_kin();

tic
for i = 1:N
    P = P_list(i);
    [Q, ~] = ik_fun(P.R, P.T, SEW, P.psi, kin, false);
    Q_testing(:,1:width(Q),i) = Q;
end
T = toc;

T_avg = T/N;
end