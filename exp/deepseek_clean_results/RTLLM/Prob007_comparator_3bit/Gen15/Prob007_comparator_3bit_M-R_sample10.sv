module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// MSB comparison
wire msb_gt = A[2] & ~B[2];
wire msb_lt = ~A[2] & B[2];
wire msb_eq = ~(A[2] ^ B[2]);

// Middle bit comparison (only if MSBs are equal)
wire mid_gt = msb_eq & A[1] & ~B[1];
wire mid_lt = msb_eq & ~A[1] & B[1];
wire mid_eq = msb_eq & ~(A[1] ^ B[1]);

// LSB comparison (only if both MSB and middle are equal)
wire lsb_gt = mid_eq & A[0] & ~B[0];
wire lsb_lt = mid_eq & ~A[0] & B[0];
wire lsb_eq = mid_eq & ~(A[0] ^ B[0]);

// Final outputs
assign A_greater = msb_gt | mid_gt | lsb_gt;
assign A_equal = msb_eq & mid_eq & lsb_eq;
assign A_less = msb_lt | mid_lt | lsb_lt;

endmodule