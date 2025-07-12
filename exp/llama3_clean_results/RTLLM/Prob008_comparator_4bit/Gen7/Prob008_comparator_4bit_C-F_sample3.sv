module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Explicit comparison for optimization
    wire A_eq_B = (A == B);
    wire A_gt_B = (A > B);
    wire A_lt_B = (A < B);

    // Assign A_equal first
    assign A_equal = A_eq_B;
    
    // Use conditional statements to determine A_greater and A_less
    assign A_greater = (A_eq_B == 1'b0) && (A_gt_B == 1'b1);
    assign A_less = (A_eq_B == 1'b0) && (A_lt_B == 1'b1);

endmodule