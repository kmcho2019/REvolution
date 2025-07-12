module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    // Perform bitwise XOR operation to compare A and B
    logic [1:0] xor_result;
    xor_result = A ^ B;
    
    // Use logical NOT operation to invert the result of the XOR operation
    z = ~(xor_result!= 0);
end

endmodule