module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    assign A_greater = (A[2] && !B[2]) || 
                        (!A[2] && B[2] ? 0 : (A[1] && !B[1])) || 
                        (!A[2] && !B[2] && !A[1] && !B[1] ? 0 : A[0] && !B[0]);

    assign A_equal = !(A_greater || A_less) && (A == B);

    assign A_less = (B[2] && !A[2]) || 
                    (!B[2] && A[2] ? 0 : (B[1] && !A[1])) || 
                    (!B[2] && !A[2] && !B[1] && !A[1] ? 0 : B[0] && !A[0]);

endmodule