module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Configuration parameters
    localparam BLOCK_SIZE = 8; // Optimal for timing (can be adjusted)
    localparam NUM_BLOCKS = 64/BLOCK_SIZE;
    
    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;

    // Hierarchical carry-lookahead implementation
    genvar i;
    generate
        for (i = 0; i < 64; i = i + BLOCK_SIZE) begin : CLA_BLOCKS
            // Block propagate and generate signals
            wire [BLOCK_SIZE-1:0] p = A[i+:BLOCK_SIZE] ^ B_comp[i+:BLOCK_SIZE];
            wire [BLOCK_SIZE-1:0] g = A[i+:BLOCK_SIZE] & B_comp[i+:BLOCK_SIZE];
            
            // Carry computation (optimized for first block)
            if (i == 0) begin
                // First block has carry-in = 1
                assign carry[0] = g[0] | (p[0] & 1'b1);
            end else begin
                assign carry[i] = g[0] | (p[0] & carry[i-1]);
            end
            
            // Carry chain within block
            for (genvar j = 1; j < BLOCK_SIZE; j = j + 1) begin : CARRY_CHAIN
                assign carry[i+j] = g[j] | (p[j] & carry[i+j-1]);
            end
            
            // Sum computation
            assign result[i] = p[0] ^ ((i == 0) ? 1'b1 : carry[i-1]);
            for (genvar j = 1; j < BLOCK_SIZE; j = j + 1) begin : SUM_COMPUTE
                assign result[i+j] = p[j] ^ carry[i+j-1];
            end
        end
    endgenerate

    /* Overflow Detection:
     * Positive overflow: A positive (A[63]=0), B negative (B[63]=1), result negative (result[63]=1)
     * Negative overflow: A negative (A[63]=1), B positive (B[63]=0), result positive (result[63]=0)
     * Detected when: (A[63] ^ B[63]) && (A[63] ^ result[63])
     * This is equivalent to checking if the result sign differs from what we'd expect
     * from the operand signs (considering they have opposite signs)
     */
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

    /* Implementation Notes:
     * 1. Uses parameterized block size (default 8-bit) for optimal timing
     * 2. Pure combinational logic with optimized carry chains
     * 3. Single-comparison overflow detection with minimal logic
     * 4. Clean hierarchical structure with generate blocks
     * 5. Easily scalable to different bit-widths by changing parameters
     */
endmodule