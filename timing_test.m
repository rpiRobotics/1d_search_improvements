%% Load tests
load('test_cases\hardcoded_IK_setup_MM50_SJ2.mat')

%%
ik_fun = @ik_mm50_rev0;
%%
ik_fun = @ik_mm50_rev1;
%%
ik_fun = @ik_mm50_rev2;
%%
ik_fun = @ik_mm50_rev0_mex;
%%
ik_fun = @ik_mm50_rev1_mex;
%%
ik_fun = @ik_mm50_rev2_mex;
%% Single pose
i =1
%% Find a missed soln

missed_idx = find(isnan(errs) | errs>1e-3);
i = missed_idx(1)
%%

P = P_list(i);

ex = [1;0;0];
ey = [0;1;0];
ez = [0;0;1];
zv = zeros(3,1);
SEW = sew_conv(rot(ey,-pi/4)*ez);
kin = hardcoded_IK_setup_MM50_SJ2.get_kin();


[Q, is_LS_vec] = ik_fun(P.R, P.T, SEW, P.psi, kin, true);hold on;
xline(S_list(i).q(1), 'r--'); hold off
[q, index_q, diff_norm] = closest_q(Q, S_list(1).q);
S_list(i).q - q

%% Compile to MEX
codegen -report ik_mm50_rev2.m -args {P.R, P.T, SEW, P.psi, kin, false}
%% Compile to MEX
codegen -report ik_mm50_rev1.m -args {P.R, P.T, SEW, P.psi, kin, false} -profile
%% Timing test

%% Compile timing test to MEX
codegen -report timing_inner.m -args {P_list}
%%
[T_avg, Q_testing] = timing_inner_mex(P_list);
vpa(T_avg * 1e6)

%% Correctness test

N = length(P_list);
errs = NaN([1 N]);
for i = 1:N
    P = P_list(i);
    [Q, is_LS_vec] = ik_fun(P.R, P.T, SEW, P.psi, kin, false);
    if ~isempty(Q)
        [q, index_q, diff_norm] = closest_q(Q, S_list(i).q);
        errs(i) = diff_norm;
    end
end

semilogy(sort(errs), 'x')
xlabel("Solution # (in order)")
ylabel("Error ||\Delta q||")
