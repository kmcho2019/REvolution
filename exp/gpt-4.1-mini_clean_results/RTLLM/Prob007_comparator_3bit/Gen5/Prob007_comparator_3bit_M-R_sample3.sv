module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

wire gt_2, gt_1, gt_0;
wire eq_2, eq_1, eq_0;
wire lt_2, lt_1, lt_0;

// Compare MSB bit 2
assign gt_2 = (A[2] & ~B[2]);
assign eq_2 = ~(A[2] ^ B[2]);
assign lt_2 = (~A[2] & B[2]);

// Compare bit 1
assign gt_1 = (A[1] & ~B[1]);
assign eq_1 = ~(A[1] ^ B[1]);
assign lt_1 = (~A[1] & B[1]);

// Compare LSB bit 0
assign gt_0 = (A[0] & ~B[0]);
assign eq_0 = ~(A[0] ^ B[0]);
assign lt_0 = (~A[0] & B[0]);

assign A_greater = gt_2 | (eq_2 & gt_1) | (eq_2 & eq_1 & gt_0);
assign A_less    = lt_2 | (eq_2 & lt_1) | (eq_2 & eq_1 & lt_0);
assign A_equal   = eq_2 & eq_1 & eq_0;

endmodule