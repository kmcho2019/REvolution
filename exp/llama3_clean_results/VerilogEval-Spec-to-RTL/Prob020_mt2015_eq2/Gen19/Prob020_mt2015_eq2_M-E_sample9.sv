module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

logic xor_result_0, xor_result_1;

always_comb begin
    // Perform XOR operation on each bit
    xor_result_0 = A[0] ^ B[0];
    xor_result_1 = A[1] ^ B[1];
    
    // Use NOR operation on XOR results to generate final output
    z = ~(xor_result_0 | xor_result_1);
end

endmodule