module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Optimized hierarchical comparison with early termination
    assign A_greater = (A[2] > B[2]) ? 1'b1 :
                      (A[2] == B[2] && A[1] > B[1]) ? 1'b1 :
                      (A[2] == B[2] && A[1] == B[1] && A[0] > B[0]) ? 1'b1 : 1'b0;

    // Most efficient equality check
    assign A_equal = (A == B);

    // Derived output ensures mutual exclusivity
    assign A_less = ~A_greater & ~A_equal;

endmodule