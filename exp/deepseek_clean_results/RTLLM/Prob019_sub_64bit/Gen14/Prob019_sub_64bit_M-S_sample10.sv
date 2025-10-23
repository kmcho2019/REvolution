module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Simple ripple-carry implementation of subtraction (A - B)
    wire [64:0] carry;  // 65-bit carry for full 64-bit operation
    
    assign carry[0] = 1'b1;  // Initialize carry-in for subtraction
    
    // Subtraction implemented as A + ~B + 1
    assign result = A ^ ~B ^ carry[63:0];
    assign carry[64:1] = (A & ~B) | ((A ^ ~B) & carry[63:0]);

    /* Overflow Detection:
     * Occurs when:
     * 1. A and B have different signs (A[63] ^ B[63])
     * 2. Result sign differs from A's sign (A[63] ^ result[63])
     */
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule