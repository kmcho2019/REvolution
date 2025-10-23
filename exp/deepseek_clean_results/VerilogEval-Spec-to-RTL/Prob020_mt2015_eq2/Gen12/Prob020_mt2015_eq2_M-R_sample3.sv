module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Bitwise equality check followed by AND reduction
    wire bit0_eq = ~(A[0] ^ B[0]);  // XNOR for LSB
    wire bit1_eq = ~(A[1] ^ B[1]);  // XNOR for MSB
    
    assign z = bit0_eq & bit1_eq;   // AND reduction
endmodule