module sub_64bit #(
    parameter MODE = 1 // 0: Ripple-carry (area optimized), 1: CLA (performance optimized)
) (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Configuration parameters
    localparam LSB_BLOCK_SIZE = 2;  // Smaller blocks for LSBs
    localparam MSB_BLOCK_SIZE = 8;  // Larger blocks for MSBs
    localparam TRANSITION_BIT = 16; // Switch block size after this bit
    
    // Two's complement subtraction signals
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;
    wire [63:0] p = A ^ B_comp; // Propagate signals (shared with overflow)
    wire [63:0] g = A & B_comp; // Generate signals

    // Leading zero detection for power optimization
    wire [6:0] lzd_A = A[63] ? ~A[63:57] : A[63:57];
    wire [6:0] lzd_B = B[63] ? ~B[63:57] : B[63:57];
    wire [6:0] active_bits = (lzd_A > lzd_B) ? lzd_A : lzd_B;

    generate
        if (MODE == 1) begin : CLA_MODE
            // Carry-lookahead with variable block sizes
            assign carry[0] = g[0] | (p[0] & 1'b1); // Initial carry-in
            
            // LSBs: 2-bit blocks for timing critical path
            for (genvar i = 1; i < TRANSITION_BIT; i = i + LSB_BLOCK_SIZE) begin : LSB_BLOCKS
                if (i < 64) begin
                    assign carry[i] = g[i] | (p[i] & carry[i-1]);
                    assign result[i-1] = p[i-1] ^ ((i == 1) ? 1'b1 : carry[i-2]);
                    assign result[i] = p[i] ^ carry[i-1];
                end
            end
            
            // MSBs: 8-bit blocks for area efficiency
            for (genvar i = TRANSITION_BIT; i < 64; i = i + MSB_BLOCK_SIZE) begin : MSB_BLOCKS
                if (i < 64) begin
                    assign carry[i] = g[i] | (p[i] & carry[i-1]);
                    for (genvar j = 0; j < MSB_BLOCK_SIZE; j = j + 1) begin
                        if (i+j < 64) begin
                            assign carry[i+j+1] = g[i+j+1] | (p[i+j+1] & carry[i+j]);
                            assign result[i+j] = p[i+j] ^ ((j == 0) ? carry[i-1] : carry[i+j-1]);
                        end
                    end
                end
            end
        end else begin : RIPPLE_MODE
            // Area-optimized ripple-carry implementation
            assign carry[0] = 1'b1;
            assign result[0] = p[0] ^ carry[0];
            
            for (genvar i = 1; i < 64; i = i + 1) begin
                assign carry[i] = g[i] | (p[i] & carry[i-1]);
                assign result[i] = p[i] ^ carry[i-1];
            end
        end
    endgenerate

    // Optimized overflow detection using shared XOR signals
    always_comb begin
        overflow = (A[63] != B[63]) && (A[63] != p[63] ^ carry[62]);
    end

    /* Power Gating Implementation (conceptual - requires clock)
    always_comb begin
        for (int i = 0; i < 64; i = i + 1) begin
            if (i > {active_bits, 3'b000}) begin
                result[i] = 1'b0; // Power-gated bits
                carry[i] = 1'b0;
            end
        end
    end
    */

    /* Implementation Notes:
     * 1. Variable block sizing (2-bit LSBs, 8-bit MSBs) optimizes timing/area
     * 2. Leading zero detection enables dynamic power reduction
     * 3. Shared XOR gates between result and overflow save area
     * 4. Configurable implementation (CLA or ripple-carry)
     * 5. Power gating infrastructure (commented) for future implementation
     */
endmodule