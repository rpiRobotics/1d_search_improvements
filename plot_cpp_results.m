cpp0 = readmatrix("cpp_errors_to_q_given_rev0.csv");
cpp1 = readmatrix("cpp_errors_to_q_given_rev1.csv");
cpp2 = readmatrix("cpp_errors_to_q_given_rev2.csv");
cpp3 = readmatrix("cpp_errors_to_q_given_rev3.csv");
cpp4 = readmatrix("cpp_errors_to_q_given_rev4.csv");
cpp5 = readmatrix("cpp_errors_to_q_given_rev5.csv");
cpp6 = readmatrix("cpp_errors_to_q_given_rev6.csv");
cpp7 = readmatrix("cpp_errors_to_q_given_rev7.csv");
cpp8 = readmatrix("cpp_errors_to_q_given_rev8.csv");


%%
semilogy(sort(cpp0), '-x'); hold on
semilogy(sort(cpp1), '-o'); 
semilogy(sort(cpp2), '-x'); 
semilogy(sort(cpp3), '-x');
semilogy(sort(cpp4), '-x'); 
semilogy(sort(cpp5), '-x'); 
semilogy(sort(cpp6), '-x'); 
semilogy(sort(cpp7), '-x'); 
semilogy(sort(cpp8), '-x'); 
semilogy(sort(errs_rev6), '-xk'); hold off

xlabel("Solution # (in order)")
ylabel("Error ||\Deltaq|| (rad)")
legend("C++ Revision 0", ...
    "C++ Revision 1", ...
    "C++ Revision 2", ...
    "C++ Revision 3", ...
    "C++ Revision 4", ...
    "C++ Revision 5", ...
    "C++ Revision 6", ...
    "C++ Revision 7", ...
    "C++ Revision 8", ...
    "MATLAB Revision 6", ...
    Location="northwest")
title("Sorted Solution Errors")

%%

semilogy(sort(cpp0), '-x'); hold on
semilogy(sort(cpp8), '-x'); 
semilogy(sort(errs_rev6), '-xk'); hold off

xlabel("Solution # (in order)")
ylabel("Error ||\Deltaq|| (rad)")
legend("C++ Revision 0", ...
    "C++ Revision 8", ...
    "MATLAB Revision 6", ...
    Location="northwest")
title("Sorted Solution Errors")
