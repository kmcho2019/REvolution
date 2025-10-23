module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Most efficient equality check
    assign A_equal = (A == B);

    // Optimized hierarchical comparison
    assign A_greater = (A[2] > B[2]) |
                      ((A[2] == B[2]) & (A[1] > B[1])) |
                      ((A[2] == B[2]) & (A[1] == B[1]) & (A[0] > B[0]);

    // Derived output - mutually exclusive
    assign A_less = ~A_greater & ~A_equal;

endmodule