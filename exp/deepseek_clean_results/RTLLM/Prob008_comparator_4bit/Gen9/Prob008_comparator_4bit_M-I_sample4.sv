module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise comparison signals
    wire [3:0] bit_eq = A ~^ B;  // XNOR for equality
    wire [3:0] bit_gt = A & ~B;  // Generate for greater

    // Parallel prefix comparison
    wire gt_3_2 = bit_gt[3] | (bit_eq[3] & bit_gt[2]);
    wire eq_3_2 = bit_eq[3] & bit_eq[2];
    
    wire gt_1_0 = bit_gt[1] | (bit_eq[1] & bit_gt[0]);
    wire eq_1_0 = bit_eq[1] & bit_eq[0];
    
    wire gt_3_0 = gt_3_2 | (eq_3_2 & gt_1_0);
    wire eq_3_0 = eq_3_2 & eq_1_0;

    // Output logic
    assign A_equal = eq_3_0;
    assign A_greater = gt_3_0 & ~eq_3_0;
    assign A_less = ~eq_3_0 & ~gt_3_0;

endmodule