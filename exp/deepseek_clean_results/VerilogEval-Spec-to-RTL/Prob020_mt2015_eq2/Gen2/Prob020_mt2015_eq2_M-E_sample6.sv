module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire bit0_match, bit1_match;
    
    // XOR each corresponding bit (result is 0 if bits match)
    assign bit0_match = A[0] ^ B[0];
    assign bit1_match = A[1] ^ B[1];
    
    // NOR the results (output 1 only when both XOR results are 0)
    assign z = ~(bit0_match | bit1_match);

endmodule