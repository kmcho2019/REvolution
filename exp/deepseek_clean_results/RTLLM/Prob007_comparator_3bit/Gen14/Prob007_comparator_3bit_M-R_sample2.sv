module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Combined difference and equality computation
wire A_gt_B_MSB = A[2] & ~B[2];
wire A_eq_B_MSB = ~(A[2] ^ B[2]);

wire A_gt_B_mid = A[1] & ~B[1] & A_eq_B_MSB;
wire A_eq_B_mid = ~(A[1] ^ B[1]) & A_eq_B_MSB;

wire A_gt_B_lsb = A[0] & ~B[0] & A_eq_B_MSB & A_eq_B_mid;
wire A_eq_B_lsb = ~(A[0] ^ B[0]) & A_eq_B_MSB & A_eq_B_mid;

// Direct output assignment with priority encoding
assign A_greater = A_gt_B_MSB | A_gt_B_mid | A_gt_B_lsb;
assign A_equal = A_eq_B_MSB & A_eq_B_mid & A_eq_B_lsb;
assign A_less = ~A_equal & ~A_greater;

endmodule