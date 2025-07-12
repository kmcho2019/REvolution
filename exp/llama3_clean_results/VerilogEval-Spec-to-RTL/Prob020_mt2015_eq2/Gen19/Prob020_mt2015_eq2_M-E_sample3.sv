module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

logic [1:0] xor_result;

always_comb begin
    // Perform bitwise XOR operation
    xor_result[1] = A[1] ^ B[1];
    xor_result[0] = A[0] ^ B[0];
    
    // Check if both bits are equal (XOR result is 0)
    z = ~(xor_result[1] | xor_result[0]);
end

endmodule