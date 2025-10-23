module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// MSB (bit 2) comparison
wire gt_msb = A[2] & ~B[2];
wire eq_msb = A[2] ~^ B[2];  // XNOR
wire lt_msb = ~A[2] & B[2];

// Middle bit (bit 1) comparison - only if MSBs are equal
wire gt_mid = eq_msb & A[1] & ~B[1];
wire eq_mid = eq_msb & (A[1] ~^ B[1]);
wire lt_mid = eq_msb & ~A[1] & B[1];

// LSB (bit 0) comparison - only if higher bits are equal
wire gt_lsb = eq_mid & A[0] & ~B[0];
wire eq_lsb = eq_mid & (A[0] ~^ B[0]);
wire lt_lsb = eq_mid & ~A[0] & B[0];

// Final outputs with priority encoding
assign A_greater = gt_msb | gt_mid | gt_lsb;
assign A_equal = eq_msb & eq_mid & eq_lsb;
assign A_less = lt_msb | lt_mid | lt_lsb;

endmodule