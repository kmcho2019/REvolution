module comparator_4bit (
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

    // Direct assignment of outputs based on comparison
    assign A_greater = A_gt_B;
    assign A_equal   = A_eq_B;
    assign A_less    = A_lt_B;

endmodule