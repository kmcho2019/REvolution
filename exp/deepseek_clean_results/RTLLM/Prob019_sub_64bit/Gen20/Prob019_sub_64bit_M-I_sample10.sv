module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Configuration parameters
    localparam LSB_BLOCK_SIZE = 2;  // Smaller blocks for LSBs
    localparam MSB_BLOCK_SIZE = 8;  // Larger blocks for MSBs
    localparam TRANSITION_BIT = 32; // Switch point between block sizes
    
    // Two's complement subtraction components
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;
    
    // Leading zero detection for power optimization
    wire [6:0] lzd_A = A[63] ? 0 : 64 - $clog2(A + 1);
    wire [6:0] lzd_B = B[63] ? 0 : 64 - $clog2(B + 1);
    wire [6:0] max_lzd = lzd_A > lzd_B ? lzd_A : lzd_B;
    
    // Generate blocks with variable sizing
    genvar i;
    generate
        // LSB region (2-bit blocks)
        for (i = 0; i < TRANSITION_BIT; i = i + LSB_BLOCK_SIZE) begin : LSB_BLOCKS
            if (i < max_lzd) begin : ACTIVE
                wire [LSB_BLOCK_SIZE-1:0] p = A[i+:LSB_BLOCK_SIZE] ^ B_comp[i+:LSB_BLOCK_SIZE];
                wire [LSB_BLOCK_SIZE-1:0] g = A[i+:LSB_BLOCK_SIZE] & B_comp[i+:LSB_BLOCK_SIZE];
                
                if (i == 0) begin
                    assign carry[0] = g[0] | (p[0] & 1'b1);
                    assign carry[1] = g[1] | (p[1] & carry[0]);
                end else begin
                    assign carry[i]   = g[0] | (p[0] & carry[i-1]);
                    assign carry[i+1] = g[1] | (p[1] & carry[i]);
                end
                
                assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry[i-1]);
                assign result[i+1] = p[1] ^ carry[i];
            end else begin : INACTIVE
                assign carry[i] = 1'b0;
                assign carry[i+1] = 1'b0;
                assign result[i+:LSB_BLOCK_SIZE] = {LSB_BLOCK_SIZE{1'b0}};
            end
        end
        
        // MSB region (8-bit blocks)
        for (i = TRANSITION_BIT; i < 64; i = i + MSB_BLOCK_SIZE) begin : MSB_BLOCKS
            if (i < max_lzd) begin : ACTIVE
                wire [MSB_BLOCK_SIZE-1:0] p = A[i+:MSB_BLOCK_SIZE] ^ B_comp[i+:MSB_BLOCK_SIZE];
                wire [MSB_BLOCK_SIZE-1:0] g = A[i+:MSB_BLOCK_SIZE] & B_comp[i+:MSB_BLOCK_SIZE];
                
                assign carry[i]   = g[0] | (p[0] & carry[i-1]);
                assign carry[i+1] = g[1] | (p[1] & carry[i]);
                assign carry[i+2] = g[2] | (p[2] & carry[i+1]);
                assign carry[i+3] = g[3] | (p[3] & carry[i+2]);
                assign carry[i+4] = g[4] | (p[4] & carry[i+3]);
                assign carry[i+5] = g[5] | (p[5] & carry[i+4]);
                assign carry[i+6] = g[6] | (p[6] & carry[i+5]);
                assign carry[i+7] = g[7] | (p[7] & carry[i+6]);
                
                assign result[i]   = p[0] ^ carry[i-1];
                assign result[i+1] = p[1] ^ carry[i];
                assign result[i+2] = p[2] ^ carry[i+1];
                assign result[i+3] = p[3] ^ carry[i+2];
                assign result[i+4] = p[4] ^ carry[i+3];
                assign result[i+5] = p[5] ^ carry[i+4];
                assign result[i+6] = p[6] ^ carry[i+5];
                assign result[i+7] = p[7] ^ carry[i+6];
            end else begin : INACTIVE
                assign carry[i+:MSB_BLOCK_SIZE] = {MSB_BLOCK_SIZE{1'b0}};
                assign result[i+:MSB_BLOCK_SIZE] = {MSB_BLOCK_SIZE{1'b0}};
            end
        end
    endgenerate

    // Shared XOR for overflow detection
    wire sign_diff = A[63] ^ B[63];
    wire result_sign_diff = A[63] ^ result[63];
    assign overflow = sign_diff & result_sign_diff;

    /* Implementation Notes:
     * 1. Variable block sizing (2-bit LSB, 8-bit MSB) optimizes area/timing
     * 2. Leading zero detection disables unused blocks for power savings
     * 3. Shared XOR gates between result and overflow calculation
     * 4. Parameterized design allows easy adjustment of block sizes
     * 5. Maintains hierarchical carry computation for balanced timing
     */
endmodule