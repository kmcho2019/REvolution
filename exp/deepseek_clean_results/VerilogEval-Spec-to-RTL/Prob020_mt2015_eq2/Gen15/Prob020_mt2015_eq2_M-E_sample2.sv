module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire bit0_match, bit1_match;
    
    // Bitwise parallel comparison
    assign bit0_match = ~(A[0] ^ B[0]);  // XNOR for bit 0
    assign bit1_match = ~(A[1] ^ B[1]);  // XNOR for bit 1
    
    // Early termination logic - any 0 kills the output
    assign z = bit0_match & bit1_match;
endmodule