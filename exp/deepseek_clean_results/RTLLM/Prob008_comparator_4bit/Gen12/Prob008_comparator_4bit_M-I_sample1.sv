module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Combined bitwise comparison (saves wiring)
    wire [3:0] gt = A & ~B;
    wire [3:0] eq = ~(A ^ B);

    // 2-bit block comparisons (balanced logic depth)
    wire gt_hi = gt[3] | (eq[3] & gt[2]);
    wire eq_hi = eq[3] & eq[2];
    wire gt_lo = gt[1] | (eq[1] & gt[0]);
    wire eq_lo = eq[1] & eq[0];

    // Final comparison (2-level logic)
    wire greater = gt_hi | (eq_hi & gt_lo);
    wire equal = eq_hi & eq_lo;

    // Optimized output logic (shared terms)
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;  // Only needs one AND gate

endmodule