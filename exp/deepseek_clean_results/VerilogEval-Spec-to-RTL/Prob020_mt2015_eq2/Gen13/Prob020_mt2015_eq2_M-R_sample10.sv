module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire bit0_equal, bit1_equal;
    
    // XOR each bit pair (result is 0 when bits are equal)
    assign bit0_equal = ~(A[0] ^ B[0]);
    assign bit1_equal = ~(A[1] ^ B[1]);
    
    // AND the equal bits to get final result
    assign z = bit0_equal & bit1_equal;
    
    /* Alternative one-line implementation:
     * assign z = (A == B);
     * But the above shows the gate-level implementation
     */
endmodule