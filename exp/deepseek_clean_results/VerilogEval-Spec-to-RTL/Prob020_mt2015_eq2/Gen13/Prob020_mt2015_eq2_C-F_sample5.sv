module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire bit0_eq = ~(A[0] ^ B[0]);  // XNOR for bit 0
    wire bit1_eq = ~(A[1] ^ B[1]);  // XNOR for bit 1
    
    assign z = bit0_eq & bit1_eq;    // AND combination

endmodule