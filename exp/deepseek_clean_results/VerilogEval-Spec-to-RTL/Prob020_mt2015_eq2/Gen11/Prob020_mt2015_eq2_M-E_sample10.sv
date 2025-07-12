module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Bit-wise equality check using XNOR gates
    wire bit0_equal = ~(A[0] ^ B[0]);  // XNOR for LSB
    wire bit1_equal = ~(A[1] ^ B[1]);  // XNOR for MSB
    
    // Combine results with AND gate
    assign z = bit0_equal & bit1_equal;
    
    /* Implementation notes:
     * - Each XNOR gate checks if corresponding bits are equal
     * - The AND gate ensures both bits must be equal
     * - This shows the fundamental gate-level implementation
     *   of equality comparison
     */
endmodule