function [Q, is_LS_vec] = ik_mm50_rev0(R_07, p_0T, SEW_class, psi, kin, show_plot)
Q = [];
is_LS_vec = [];

W = p_0T - R_07 * kin.P(:,8);
p_1W = W - kin.P(:,1);

e_fun = @(q1)(wrapToPi(psi_given_q1(q1) - psi));
[q1_vec, soln_num_vec] = search_1D(e_fun, -pi, pi, 1e3, show_plot);

for i_q1 = 1:length(q1_vec)
    [~, partial_Q] = psi_given_q1(q1_vec(i_q1));
    partial_q = partial_Q(:,soln_num_vec(i_q1));
        R_01 = rot(kin.H(:,1), partial_q(1));
        R_12 = rot(kin.H(:,2), partial_q(2));
        R_23 = rot(kin.H(:,3), partial_q(3));
        R_34 = rot(kin.H(:,4), partial_q(4));
        R_04 = R_01 * R_12 * R_23 * R_34;
        [t5, t6, t_56_is_LS] = subproblem.sp_2(R_04'*R_07*kin.H(:,7), kin.H(:,7), -kin.H(:,5), kin.H(:,6));
        for i_56 = 1:length(t5)
            q5 = t5(i_56);
            q6 = t6(i_56);
            R_45 = rot(kin.H(:,5), q5);
            R_56 = rot(kin.H(:,6), q6);
            p = kin.H(:,6); % non-collinear with h_7
            R_06 = R_04 * R_45 * R_56;
            [q7, q7_is_LS] = subproblem.sp_1(p, R_06' * R_07 * p, kin.H(:,7));
            q_i = [partial_q; q5; q6; q7];
            Q = [Q q_i];
            is_LS_vec = [is_LS_vec t_56_is_LS||q7_is_LS];
        end
end


function [psi_vec, partial_Q] = psi_given_q1(q1)
    psi_vec = NaN(1,4);
    partial_Q = NaN(4,4);
    i_soln = 1;

    p_1S = rot(kin.H(:,1), q1)*kin.P(:,2);
    p_SW = p_1W - p_1S;

    % Solve for q4 with subproblem 3
    [t4, t4_is_LS] = subproblem.sp_3(kin.P(:,5), -kin.P(:,4), kin.H(:,4), norm(p_SW));
    if t4_is_LS
        return
    end
    for i_4 = 1:length(t4)
        q4 = t4(i_4);
        
        % Solve for (q_2, q_3) with Subproblem 2 to place the wrist
        [t2, t3, t23_is_LS] = subproblem.sp_2(rot(kin.H(:,1), q1)'*p_SW, kin.P(:,4)+rot(kin.H(:,4),q4)*kin.P(:,5), -kin.H(:,2), kin.H(:,3));
        if t23_is_LS
            i_soln = i_soln + 2;
            continue
        end
        for i_23 = 1:length(t2)
            q2 = t2(i_23);
            q3 = t3(i_23);

            p_1E = p_1S + rot(kin.H(:,1), q1)*rot(kin.H(:,2), q2)*rot(kin.H(:,3), q3)*kin.P(:,4);
            psi_i = SEW_class.fwd_kin(p_1S, p_1E, p_1W);
            psi_vec(i_soln) = psi_i;
            partial_Q(:, i_soln) = [q1; q2; q3; q4];
            i_soln = i_soln + 1;
        end
    end
    
end

end


function [x_vec, soln_num_vec] = search_1D(fun, x1, x2, N, show_plot)
% Inputs
%   Minimization function (vector valued)
%   Search interval
%   Number of initial samples
%   Plotting on/off
% Outputs
%   Vector of zeros locations
%   Vector of which index of the function has the zero

% Sample the search space
x_sample_vec = linspace(x1, x2, N);
e_1 = fun(x_sample_vec(1)); % Use to find size
e_mat = NaN([length(e_1) N]);
e_mat(:,1) = e_1;
for i = 2:N
    e_mat(:,i) = fun(x_sample_vec(i));
end

% Find zero crossings
% Ignore very large crossings, as this may be caused by angle wrapping
CROSS_THRESH = 0.1;
zero_cross_direction = diff(e_mat<0, 1,2)~=0 & abs(e_mat(:,2:end)) < CROSS_THRESH & abs(e_mat(:,1:end-1)) < CROSS_THRESH;
has_zero_cross = sum(abs(zero_cross_direction));
crossings_left = x_sample_vec(has_zero_cross>0);
crossings_right = x_sample_vec([false has_zero_cross>0]);

crossing_soln_nums = zero_cross_direction(:,has_zero_cross>0);
n_zeros = sum(crossing_soln_nums(:));

% Iterate on each bracket
options = optimset('Display','off', 'TolX', 1e-5); % was 1e-5
% options = optimset('Display','off'); % was 1e-5
ind_soln = 1;
x_vec = NaN(1, n_zeros);
soln_num_vec = NaN(1, n_zeros);
for i = 1:length(crossings_left)
    soln_nums = find(crossing_soln_nums(:,i));
    for i_soln_num = 1:length(soln_nums)
        soln_num = soln_nums(i_soln_num);
        x_vec(ind_soln) = fzero(@(x)(select_soln(fun(x),soln_num)), [crossings_left(i) crossings_right(i)], options);
        soln_num_vec(ind_soln) = soln_num;
        ind_soln = ind_soln + 1;
    end
end

% Plot results
if show_plot
    plot(x_sample_vec, e_mat, '.');
    yline(0);
    if ~isempty(x_vec)
        xline(x_vec);
    end
end

end

function x = select_soln(x_arr, soln_num)
    x = x_arr(soln_num);
end