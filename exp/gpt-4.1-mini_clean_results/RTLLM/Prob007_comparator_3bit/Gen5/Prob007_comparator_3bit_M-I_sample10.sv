module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Intermediate wire declarations for bitwise comparison
wire bit2_gt = A[2] & ~B[2];
wire bit2_lt = ~A[2] & B[2];

wire bit1_gt = A[1] & ~B[1];
wire bit1_lt = ~A[1] & B[1];

wire bit0_gt = A[0] & ~B[0];
wire bit0_lt = ~A[0] & B[0];

assign A_greater = bit2_gt 
                | (~bit2_gt & ~bit2_lt & bit1_gt) 
                | (~bit2_gt & ~bit2_lt & ~bit1_gt & ~bit1_lt & bit0_gt);

assign A_less    = bit2_lt 
                | (~bit2_gt & ~bit2_lt & bit1_lt) 
                | (~bit2_gt & ~bit2_lt & ~bit1_gt & ~bit1_lt & bit0_lt);

assign A_equal   = ~(A_greater | A_less);

endmodule