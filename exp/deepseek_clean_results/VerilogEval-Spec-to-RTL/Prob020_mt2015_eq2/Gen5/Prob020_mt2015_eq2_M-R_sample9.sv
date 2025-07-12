module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Compare each bit pair and AND the results
    wire bit0_equal = ~(A[0] ^ B[0]);  // XNOR
    wire bit1_equal = ~(A[1] ^ B[1]);  // XNOR
    
    assign z = bit0_equal & bit1_equal;

endmodule