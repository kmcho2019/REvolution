module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-wise comparison signals
wire A_gt_B2 = A[2] & ~B[2];
wire A_eq_B2 = A[2] ~^ B[2];
wire A_lt_B2 = ~A[2] & B[2];

wire A_gt_B1 = A[1] & ~B[1];
wire A_eq_B1 = A[1] ~^ B[1];
wire A_lt_B1 = ~A[1] & B[1];

wire A_gt_B0 = A[0] & ~B[0];
wire A_eq_B0 = A[0] ~^ B[0];
wire A_lt_B0 = ~A[0] & B[0];

// Hierarchical comparison logic
assign A_greater = A_gt_B2 | 
                  (A_eq_B2 & A_gt_B1) | 
                  (A_eq_B2 & A_eq_B1 & A_gt_B0);

assign A_equal = A_eq_B2 & A_eq_B1 & A_eq_B0;

assign A_less = A_lt_B2 | 
               (A_eq_B2 & A_lt_B1) | 
               (A_eq_B2 & A_eq_B1 & A_lt_B0);

endmodule