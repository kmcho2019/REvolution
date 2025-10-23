module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [2:0] A_gt_B = A > B;
    wire [2:0] A_eq_B = A == B;

    // Parallel comparison for first two bits, then final bit
    assign A_greater = A_gt_B[2] | 
                      (A_eq_B[2] & A_gt_B[1]) | 
                      (A_eq_B[2] & A_eq_B[1] & A_gt_B[0]);

    // Gated equality check (only when not greater)
    assign A_equal = ~A_greater & &A_eq_B;

    // Optimized derived output
    assign A_less = ~A_greater & ~A_equal;

endmodule