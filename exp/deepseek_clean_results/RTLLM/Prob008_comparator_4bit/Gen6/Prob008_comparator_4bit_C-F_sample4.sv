module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Efficient equality check using XNOR and reduction AND
    wire [3:0] bit_equal = ~(A ^ B);
    wire equal = &bit_equal;

    // Carry-lookahead inspired greater-than comparison
    wire gt_3 = A[3] & ~B[3];
    wire gt_2 = bit_equal[3] & (A[2] & ~B[2]);
    wire gt_1 = &bit_equal[3:2] & (A[1] & ~B[1]);
    wire gt_0 = &bit_equal[3:1] & (A[0] & ~B[0]);

    // Combined greater-than signal (3-level logic)
    wire greater = gt_3 | gt_2 | gt_1 | gt_0;

    // Optimized output assignments
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~(equal | greater);  // Most efficient less-than implementation

endmodule