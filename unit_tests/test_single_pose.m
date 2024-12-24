n = 7250;
P = P_list(n);
S = S_list(n);

ex = [1;0;0];
ey = [0;1;0];
ez = [0;0;1];
zv = zeros(3,1);
SEW = sew_conv(rot(ey,-pi/4)*ez);
kin = hardcoded_IK_setup_MM50_SJ2.get_kin();

[Q, is_LS_vec] = ik_mm50_rev6(P.R, P.T, SEW, P.psi, kin, true)

[~, ~, e] = closest_q(Q, S.q)