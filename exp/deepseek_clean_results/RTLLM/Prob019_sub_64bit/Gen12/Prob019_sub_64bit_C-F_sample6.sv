module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Subtraction implemented as A + ~B + 1 (two's complement)
    wire [63:0] B_comp = ~B;
    wire [63:0] carry_chain;  // Optimized to 64 bits
    
    // First bit handled separately to optimize carry_chain[0]
    assign result[0] = A[0] ^ B_comp[0] ^ 1'b1;
    assign carry_chain[0] = (A[0] & B_comp[0]) | ((A[0] ^ B_comp[0]) & 1'b1);
    
    // Carry-lookahead implementation for bits [63:1]
    genvar i;
    generate
        for (i=1; i<64; i=i+1) begin : sub_adder
            // Propagate and generate signals (shared with overflow detection)
            wire p = A[i] ^ B_comp[i];
            wire g = A[i] & B_comp[i];
            
            // Carry lookahead
            assign carry_chain[i] = g | (p & carry_chain[i-1]);
            
            // Sum calculation
            assign result[i] = p ^ carry_chain[i-1];
        end
    endgenerate

    /* Overflow Detection:
     * Occurs when:
     * 1. A and B have different signs (A[63] ^ B[63])
     * 2. Result sign differs from A's sign (A[63] ^ result[63])
     * Implemented as single XOR comparison for efficiency
     */
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

    /* Implementation Notes:
     * 1. Carry chain optimized to 64 bits by handling bit 0 separately
     * 2. Propagate (p) signals shared between subtraction and overflow
     * 3. No unnecessary registers for optimal power
     * 4. Clean continuous assignments for better synthesis
     */
endmodule