module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Stage 1: MSB comparison
wire msb_gt = A[2] & ~B[2];
wire msb_lt = ~A[2] & B[2];
wire msb_eq = ~(msb_gt | msb_lt);

// Stage 2: Middle bit comparison (only if MSBs equal)
wire mid_gt = msb_eq & A[1] & ~B[1];
wire mid_lt = msb_eq & ~A[1] & B[1];
wire mid_eq = msb_eq & ~(mid_gt | mid_lt);

// Stage 3: LSB comparison (only if both MSB and middle bits equal)
wire lsb_gt = mid_eq & A[0] & ~B[0];
wire lsb_lt = mid_eq & ~A[0] & B[0];

// Final output determination
assign A_greater = msb_gt | mid_gt | lsb_gt;
assign A_less = msb_lt | mid_lt | lsb_lt;
assign A_equal = mid_eq & (A[0] ~^ B[0]);

endmodule