module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Intermediate signals for bit-wise comparison
wire match_bit0;
wire match_bit1;

// Compare each bit of A with the corresponding bit of B
assign match_bit0 = A[0] == B[0];
assign match_bit1 = A[1] == B[1];

// Use logical AND to ensure all bits match
assign z = match_bit0 && match_bit1;

endmodule