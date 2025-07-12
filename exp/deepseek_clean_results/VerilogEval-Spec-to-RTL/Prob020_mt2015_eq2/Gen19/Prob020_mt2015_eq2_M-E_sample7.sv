module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire mismatch0, mismatch1;
    wire any_mismatch;
    
    // Bitwise comparison
    assign mismatch0 = A[0] ^ B[0];  // XOR for bit 0
    assign mismatch1 = A[1] ^ B[1];  // XOR for bit 1
    
    // Combine mismatch signals
    assign any_mismatch = mismatch0 | mismatch1;
    
    // Final equality output
    assign z = ~any_mismatch;
endmodule