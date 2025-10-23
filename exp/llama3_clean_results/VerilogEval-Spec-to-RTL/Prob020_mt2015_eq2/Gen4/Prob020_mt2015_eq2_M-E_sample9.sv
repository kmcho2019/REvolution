module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

wire xor_bit0, xor_bit1;

// Perform bitwise XOR operations
assign xor_bit0 = A[0] ^ B[0];
assign xor_bit1 = A[1] ^ B[1];

// Determine overall equality
assign z = ~(xor_bit0 | xor_bit1);

endmodule