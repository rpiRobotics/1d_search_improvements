classdef hardcoded_IK_setup_MM50_SJ2

methods (Static)
    function kin = get_kin()
    % https://www.motoman.com/en-us/products/robots/industrial/assembly-handling/sia-series/sia50d

    d1 = 0.540;
    a1 = 0.145;
    d3 = 0.875;
    d5 = 0.610;
    dT = 0.350;

    ex = [1;0;0];
    ey = [0;1;0];
    ez = [0;0;1];
    zv = zeros(3,1);

    kin.P = [d1*ez a1*ex zv d3*ez d5*ez zv zv dT*ez];
    kin.H = [ez -ey ez -ey ez -ey ez];
    kin.joint_type = [0 0 0 0 0 0 0];
    end

    function [P, S] = setup()
        ex = [1;0;0];
        ey = [0;1;0];
        ez = [0;0;1];
        zv = zeros(3,1);

        SEW = sew_conv(rot(ey,-pi/4)*ez);
        kin = hardcoded_IK_setup_MM50_SJ2.get_kin();

        S.q = rand_angle([7 1]);
        
        [P.R, P.T, P_SEW] = fwdkin_inter(kin, S.q, [2 4 5]);
        p_S = P_SEW(:,1); % Shoulder (NOT constant in this example!)
        p_E = P_SEW(:,2); % Elbow
        p_W = P_SEW(:,3); % Wrist
        
        P.psi = SEW.fwd_kin(p_S, p_E, p_W); % SEW angle
    end
    
    function S = run(P)
        ex = [1;0;0];
        ey = [0;1;0];
        ez = [0;0;1];
        zv = zeros(3,1);
        SEW = sew_conv(rot(ey,-pi/4)*ez);
        kin = hardcoded_IK_setup_MM50_SJ2.get_kin();
        [S.Q, S.is_LS] = SEW_IK.IK_R_2R_R_3R_SJ2(P.R, P.T, SEW, P.psi, kin, false);
    end
    % 
    % function S = run_mex(P)
    %     [S.Q, S.is_LS] = hardcoded_IK.ur5_mex(P.R, P.T);
    % end
    % 
    % function [e, e_R, e_T] = error(P,S)
    %     P.kin = hardcoded_IK_setups.ur5.get_kin();
    %     [e, e_R, e_T] = robot_IK_error(P, S);
    % end
end
end