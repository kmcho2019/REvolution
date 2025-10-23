module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Compare upper and lower 2-bit chunks
wire upper_gt = (A[3:2] > B[3:2]);
wire upper_eq = (A[3:2] == B[3:2]);
wire upper_lt = (A[3:2] < B[3:2]);

wire lower_gt = (A[1:0] > B[1:0]);
wire lower_eq = (A[1:0] == B[1:0]);
wire lower_lt = (A[1:0] < B[1:0]);

// Combine results using prefix rules
assign A_greater = upper_gt | (upper_eq & lower_gt);
assign A_equal = upper_eq & lower_eq;
assign A_less = upper_lt | (upper_eq & lower_lt);

endmodule