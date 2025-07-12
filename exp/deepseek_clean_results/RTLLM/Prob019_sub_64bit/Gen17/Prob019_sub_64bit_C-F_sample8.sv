module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Local parameters for improved readability
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;
    localparam BLOCK_SIZE = 4; // CLA block size for flexibility

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry_chain; // Packed array for efficient carry storage

    // Hierarchical carry-lookahead adder with optimized blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+BLOCK_SIZE) begin : CLA_BLOCKS
            // Block propagate and generate terms
            wire [BLOCK_SIZE-1:0] p = A[i+:BLOCK_SIZE] ^ B_comp[i+:BLOCK_SIZE];
            wire [BLOCK_SIZE-1:0] g = A[i+:BLOCK_SIZE] & B_comp[i+:BLOCK_SIZE];
            
            // Optimized carry computation within block
            wire [BLOCK_SIZE-1:0] carry;
            assign carry[0] = g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1]));
            
            // Chain carries within the block
            generate
                for (genvar j=1; j<BLOCK_SIZE; j=j+1) begin : CARRY_CHAIN
                    assign carry[j] = g[j] | (p[j] & carry[j-1]);
                end
            endgenerate
            
            // Store carries for next block
            assign carry_chain[i+:BLOCK_SIZE] = carry;
            
            // Compute result bits
            assign result[i] = p[0] ^ ((i == 0) ? 1'b1 : carry_chain[i-1]);
            generate
                for (genvar k=1; k<BLOCK_SIZE; k=k+1) begin : RESULT_BITS
                    assign result[i+k] = p[k] ^ carry[k-1];
                end
            endgenerate
        end
    endgenerate

    /* Overflow Detection:
     * Overflow occurs when:
     * 1. Positive overflow: A positive (A[63]=0), B negative (B[63]=1), result negative (result[63]=1)
     * 2. Negative overflow: A negative (A[63]=1), B positive (B[63]=0), result positive (result[63]=0)
     * Simplified to: (A[63] != B[63]) && (A[63] != result[63])
     */
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]) ? OVERFLOW : NO_OVERFLOW;

endmodule