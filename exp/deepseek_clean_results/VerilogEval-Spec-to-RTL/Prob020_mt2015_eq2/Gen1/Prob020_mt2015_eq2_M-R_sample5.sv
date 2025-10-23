module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire bit0_match, bit1_match;
    
    assign bit0_match = ~(A[0] ^ B[0]);  // XNOR using XOR and NOT
    assign bit1_match = ~(A[1] ^ B[1]);  // XNOR using XOR and NOT
    assign z = bit0_match & bit1_match;

endmodule