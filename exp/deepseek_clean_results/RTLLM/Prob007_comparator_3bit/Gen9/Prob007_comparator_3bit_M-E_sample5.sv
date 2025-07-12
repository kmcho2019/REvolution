module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// One-hot encoding of inputs
wire [7:0] A_onehot = (1 << A);
wire [7:0] B_onehot = (1 << B);

// Parallel comparison logic
wire [7:0] gt_mask = A_onehot & ~(B_onehot - 1);
wire [7:0] lt_mask = B_onehot & ~(A_onehot - 1);

// Output determination
assign A_greater = |gt_mask;
assign A_less = |lt_mask;
assign A_equal = (A == B);  // Direct equality check is simpler

endmodule