module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire bit0_eq, bit1_eq;
    
    // Bit-wise equality comparison
    xnor xnor0(bit0_eq, A[0], B[0]);
    xnor xnor1(bit1_eq, A[1], B[1]);
    
    // Combine results
    and and0(z, bit0_eq, bit1_eq);

endmodule