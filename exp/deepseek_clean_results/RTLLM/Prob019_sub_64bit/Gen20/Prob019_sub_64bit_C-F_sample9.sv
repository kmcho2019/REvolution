module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Local parameters for clear overflow signaling
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [64:0] carry;  // 65-bit carry for full 64-bit operation
    
    assign carry[0] = 1'b1;  // Initialize carry-in for subtraction
    
    // Subtraction implemented as A + ~B + 1
    assign result = A ^ ~B ^ carry[63:0];
    assign carry[64:1] = (A & ~B) | ((A ^ ~B) & carry[63:0]);

    /* Overflow Detection:
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Detected when:
     * - Signs of A and B differ (A[63] ^ B[63])
     * - Result sign differs from A (A[63] ^ result[63])
     */
    assign overflow = ((A[63] ^ B[63]) & (A[63] ^ result[63])) ? OVERFLOW : NO_OVERFLOW;

    /* Implementation Notes:
     * 1. Simple ripple-carry implementation for area efficiency
     * 2. Clear overflow detection with documented conditions
     * 3. Continuous assignments for optimal synthesis
     * 4. Local parameters improve code readability
     * 5. 65-bit carry ensures correct operation for all cases
     */
endmodule