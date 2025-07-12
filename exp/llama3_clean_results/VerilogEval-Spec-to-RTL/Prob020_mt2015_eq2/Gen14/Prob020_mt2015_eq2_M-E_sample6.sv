module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);
    
    wire [1:0] xor_result;
    
    // Perform XOR operation between A and B
    assign xor_result = A ^ B;
    
    // Check if xor_result is zero, if yes, then A == B
    assign z = ~(xor_result[1] | xor_result[0]);
    
endmodule