module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire bit0_eq, bit1_eq;
    
    // Bitwise equality checks
    assign bit0_eq = ~(A[0] ^ B[0]);  // XNOR equivalent
    assign bit1_eq = ~(A[1] ^ B[1]);  // XNOR equivalent
    
    // Combine results
    assign z = bit0_eq & bit1_eq;
endmodule