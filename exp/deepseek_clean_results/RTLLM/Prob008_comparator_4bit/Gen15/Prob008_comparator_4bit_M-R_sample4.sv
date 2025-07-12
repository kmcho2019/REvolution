module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// MSB first comparison (bit 3 is MSB)
wire cmp3_gt = (A[3] > B[3]);
wire cmp3_eq = (A[3] == B[3]);
wire cmp3_lt = (A[3] < B[3]);

wire cmp2_gt = (A[2] > B[2]);
wire cmp2_eq = (A[2] == B[2]);
wire cmp2_lt = (A[2] < B[2]);

wire cmp1_gt = (A[1] > B[1]);
wire cmp1_eq = (A[1] == B[1]);
wire cmp1_lt = (A[1] < B[1]);

wire cmp0_gt = (A[0] > B[0]);
wire cmp0_eq = (A[0] == B[0]);
wire cmp0_lt = (A[0] < B[0]);

// Priority encoded outputs
assign A_greater = cmp3_gt | 
                  (cmp3_eq & cmp2_gt) |
                  (cmp3_eq & cmp2_eq & cmp1_gt) |
                  (cmp3_eq & cmp2_eq & cmp1_eq & cmp0_gt);

assign A_equal = cmp3_eq & cmp2_eq & cmp1_eq & cmp0_eq;

assign A_less = cmp3_lt | 
               (cmp3_eq & cmp2_lt) |
               (cmp3_eq & cmp2_eq & cmp1_lt) |
               (cmp3_eq & cmp2_eq & cmp1_eq & cmp0_lt);

endmodule