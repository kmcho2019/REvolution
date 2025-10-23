module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

logic xor_result[1:0];

always_comb begin
    // Use XOR gates to compare the corresponding bits of A and B
    xor_result[0] = A[0] ^ B[0];
    xor_result[1] = A[1] ^ B[1];
    
    // Use a NOR gate to detect when all bits are the same (i.e., when the XOR result is all zeros)
    z = ~(xor_result[0] | xor_result[1]);
end

endmodule