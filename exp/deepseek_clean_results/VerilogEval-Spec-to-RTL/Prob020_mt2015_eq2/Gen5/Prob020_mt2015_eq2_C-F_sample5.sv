module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Behavioral equality comparison (synthesizes to 2 XNOR + 1 AND)
    assign z = (A == B);

    /* Equivalent gate-level implementation:
     * wire bit0_equal = ~(A[0] ^ B[0]);
     * wire bit1_equal = ~(A[1] ^ B[1]);
     * assign z = bit0_equal & bit1_equal;
     */
endmodule