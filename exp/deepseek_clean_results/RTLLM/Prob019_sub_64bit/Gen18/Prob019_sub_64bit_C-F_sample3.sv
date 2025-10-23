module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Configuration parameters
    localparam BLOCK_SIZE = 8;  // 8-bit carry-lookahead blocks
    localparam NUM_BLOCKS = 64/BLOCK_SIZE;
    
    // Local parameters for documentation
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;

    // Generate propagate and generate terms
    wire [63:0] p = A ^ B_comp;
    wire [63:0] g = A & B_comp;

    // Hierarchical carry computation with Brent-Kung style prefix tree
    genvar i, j;
    generate
        // First level: Compute block-level carries
        for (i=0; i<64; i=i+BLOCK_SIZE) begin : BLOCK_CARRIES
            if (i == 0) begin
                // First block gets carry-in = 1
                assign carry[0] = g[0] | (p[0] & 1'b1);
            end else begin
                // Other blocks get carry from previous block
                assign carry[i] = g[i] | (p[i] & carry[i-1]);
            end
            
            // Compute remaining carries within block
            for (j=1; j<BLOCK_SIZE; j=j+1) begin : WITHIN_BLOCK
                assign carry[i+j] = g[i+j] | (p[i+j] & carry[i+j-1]);
            end
        end

        // Second level: Optimized carry propagation between blocks
        for (i=BLOCK_SIZE; i<64; i=i+BLOCK_SIZE) begin : CROSS_BLOCK
            wire [BLOCK_SIZE-1:0] block_p;
            wire [BLOCK_SIZE-1:0] block_g;
            
            // Compute block propagate and generate
            assign block_p[0] = &p[i-BLOCK_SIZE+:BLOCK_SIZE];
            assign block_g[0] = g[i-1] | 
                               (p[i-1] & (g[i-2] | 
                               (p[i-2] & (g[i-3] | 
                               (p[i-3] & (g[i-4] | 
                               (p[i-4] & (g[i-5] | 
                               (p[i-5] & (g[i-6] | 
                               (p[i-6] & g[i-7])))))))));
            
            // Update carries using block PG
            for (j=0; j<BLOCK_SIZE; j=j+1) begin : UPDATE_CARRIES
                assign carry[i+j] = g[i+j] | (p[i+j] & (block_g[0] | (block_p[0] & carry[i-BLOCK_SIZE])));
            end
        end

        // Sum computation
        for (i=0; i<64; i=i+1) begin : SUM
            assign result[i] = p[i] ^ ((i == 0) ? 1'b1 : carry[i-1]);
        end
    endgenerate

    // Efficient overflow detection with early prediction
    wire a_sign = A[63];
    wire b_sign = B[63];
    wire r_sign = result[63];
    
    assign overflow = (a_sign != b_sign) && (a_sign != r_sign) ? OVERFLOW : NO_OVERFLOW;

    /* Overflow Conditions:
     * 1. Positive overflow: A positive (0), B negative (1), result negative (1)
     * 2. Negative overflow: A negative (1), B positive (0), result positive (0)
     * Detected when:
     * - Signs of A and B differ (a_sign != b_sign)
     * - Result sign differs from A (a_sign != r_sign)
     */
endmodule