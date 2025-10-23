module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Intermediate comparison results for each bit
    wire [3:0] A_gt_B_bit;
    wire [3:0] A_eq_B_bit;
    wire [3:0] A_lt_B_bit;

    // Bit-wise comparison
    assign A_gt_B_bit[3] = (A[3] & ~B[3]);
    assign A_eq_B_bit[3] = (A[3] ~^ B[3]);
    assign A_lt_B_bit[3] = (~A[3] & B[3]);

    assign A_gt_B_bit[2] = A_eq_B_bit[3] & (A[2] & ~B[2]);
    assign A_eq_B_bit[2] = A_eq_B_bit[3] & (A[2] ~^ B[2]);
    assign A_lt_B_bit[2] = A_eq_B_bit[3] & (~A[2] & B[2]);

    assign A_gt_B_bit[1] = A_eq_B_bit[2] & (A[1] & ~B[1]);
    assign A_eq_B_bit[1] = A_eq_B_bit[2] & (A[1] ~^ B[1]);
    assign A_lt_B_bit[1] = A_eq_B_bit[2] & (~A[1] & B[1]);

    assign A_gt_B_bit[0] = A_eq_B_bit[1] & (A[0] & ~B[0]);
    assign A_eq_B_bit[0] = A_eq_B_bit[1] & (A[0] ~^ B[0]);
    assign A_lt_B_bit[0] = A_eq_B_bit[1] & (~A[0] & B[0]);

    // Final outputs
    assign A_greater = A_gt_B_bit[3] | A_gt_B_bit[2] | A_gt_B_bit[1] | A_gt_B_bit[0];
    assign A_equal = A_eq_B_bit[0];
    assign A_less = A_lt_B_bit[3] | A_lt_B_bit[2] | A_lt_B_bit[1] | A_lt_B_bit[0];

endmodule