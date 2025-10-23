module sub_64bit (
    input signed [63:0] A,    // First signed operand
    input signed [63:0] B,    // Second signed operand (subtracted from A)
    output signed [63:0] result,  // Signed result of A - B
    output overflow           // Overflow flag
);

    // Signed subtraction operation
    assign result = A - B;
    
    /* Overflow occurs when:
     * 1. Operands have opposite signs (A negative, B positive or vice versa)
     * 2. Result sign doesn't match expected sign (same as A's sign)
     * Implemented efficiently using XOR operations:
     * First XOR checks for opposite signs between operands
     * Second XOR checks if result sign differs from A's sign
     */
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule