module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [3:0] onehot_A;
wire [3:0] onehot_B;

// Decode 2-bit input into one-hot encoding
assign onehot_A = 4'b0001 << A;
assign onehot_B = 4'b0001 << B;

// Check if exactly one bit is common (i.e., inputs equal)
assign z = |(onehot_A & onehot_B);

endmodule