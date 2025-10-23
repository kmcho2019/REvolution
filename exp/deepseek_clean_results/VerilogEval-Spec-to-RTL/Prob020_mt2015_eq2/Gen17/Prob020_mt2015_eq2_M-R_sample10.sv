module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Bit-wise equality comparison using XNOR and AND
    wire bit0_equal = ~(A[0] ^ B[0]);  // XNOR for LSB
    wire bit1_equal = ~(A[1] ^ B[1]);  // XNOR for MSB
    
    assign z = bit0_equal & bit1_equal;  // AND of both comparisons
endmodule