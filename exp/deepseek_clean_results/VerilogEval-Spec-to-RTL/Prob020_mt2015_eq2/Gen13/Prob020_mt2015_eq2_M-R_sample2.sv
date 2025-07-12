module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Bitwise equality comparison using XNOR + AND reduction
    wire bit0_equal = ~(A[0] ^ B[0]);  // XNOR for LSB
    wire bit1_equal = ~(A[1] ^ B[1]);  // XNOR for MSB
    
    assign z = bit0_equal & bit1_equal;  // AND reduction for final result
endmodule