module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality and comparison signals
    wire [3:0] eq = ~(A ^ B);  // NOR implementation of equality
    wire [3:0] gt = A & ~B;    // Direct greater-than terms

    // Hierarchical comparison with carry-lookahead approach
    wire gt_3 = gt[3];
    wire gt_2 = eq[3] & gt[2];
    wire gt_1 = eq[3] & eq[2] & gt[1];
    wire gt_0 = eq[3] & eq[2] & eq[1] & gt[0];

    // Combined greater-than signal (3-level logic)
    wire greater = gt_3 | gt_2 | gt_1 | gt_0;

    // Complete equality (4-input AND of eq bits)
    wire equal = &eq;

    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = greater;  // greater already implies ~equal
    assign A_less = ~(equal | greater);  // Most efficient way to get less

endmodule