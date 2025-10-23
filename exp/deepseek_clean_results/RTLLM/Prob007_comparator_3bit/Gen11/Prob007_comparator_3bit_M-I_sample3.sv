module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// MSB comparison (highest priority)
wire gt_msb = A[2] & ~B[2];
wire eq_msb = ~(A[2] ^ B[2]);

// Middle bit comparison (only if MSB equal)
wire gt_mid = eq_msb & A[1] & ~B[1];
wire eq_mid = eq_msb & ~(A[1] ^ B[1]);

// LSB comparison (only if both higher bits equal)
wire gt_lsb = eq_mid & A[0] & ~B[0];
wire eq_all = eq_mid & ~(A[0] ^ B[0]);

// Final outputs (mutually exclusive)
assign A_greater = gt_msb | gt_mid | gt_lsb;
assign A_equal = eq_all;
assign A_less = ~(A_greater | A_equal);  // Only when A < B

endmodule