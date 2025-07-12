module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [64:0] carry;  // Extra bit for final carry out

    // Initialize first carry bit for +1 operation
    assign carry[0] = 1'b1;

    // Ripple-carry subtraction implementation
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : SUB_BITS
            assign result[i] = A[i] ^ B_comp[i] ^ carry[i];
            assign carry[i+1] = (A[i] & B_comp[i]) | 
                               ((A[i] ^ B_comp[i]) & carry[i]);
        end
    endgenerate

    /* Overflow Detection:
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Implemented as: (A[63] ^ B[63]) && (A[63] ^ result[63])
     */
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

    /* Implementation Notes:
     * 1. Uses ripple-carry structure for simplicity and readability
     * 2. Explicitly shows the two's complement subtraction logic
     * 3. Maintains efficient overflow detection
     * 4. Clean separation of subtraction and overflow logic
     */
endmodule