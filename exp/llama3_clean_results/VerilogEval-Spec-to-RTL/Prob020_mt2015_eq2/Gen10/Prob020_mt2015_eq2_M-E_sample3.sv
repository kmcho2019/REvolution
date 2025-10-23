module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Perform bitwise XOR between A and B
wire xor_result0 = A[0] ^ B[0];
wire xor_result1 = A[1] ^ B[1];

// Apply NOR operation to the XOR results
assign z = ~(xor_result0 | xor_result1);

endmodule