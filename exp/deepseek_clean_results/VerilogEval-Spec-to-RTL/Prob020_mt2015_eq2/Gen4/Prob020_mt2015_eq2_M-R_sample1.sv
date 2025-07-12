module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire bit0_equal, bit1_equal;
    
    assign bit0_equal = ~(A[0] ^ B[0]);  // XNOR for bit 0 equality
    assign bit1_equal = ~(A[1] ^ B[1]);  // XNOR for bit 1 equality
    assign z = bit0_equal & bit1_equal;  // AND to combine results

endmodule