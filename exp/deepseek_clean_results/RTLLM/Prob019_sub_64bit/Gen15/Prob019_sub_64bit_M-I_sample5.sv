module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Parameters for hierarchical carry-lookahead
    localparam BLOCK_SIZE = 4;
    localparam NUM_BLOCKS = 64/BLOCK_SIZE;
    
    // Local parameters for documentation
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    // Two's complement subtraction signals
    wire [63:0] B_comp = ~B;
    wire [63:0] p, g;       // Propagate and generate signals
    wire [NUM_BLOCKS:0] carry_block; // Block carry chain

    // First stage: Initial carry-in
    assign carry_block[0] = 1'b1;  // +1 for two's complement

    // Hierarchical carry-lookahead implementation
    genvar i, j;
    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : block
            // Block propagate and generate
            wire block_p = &p[i*BLOCK_SIZE +: BLOCK_SIZE];
            wire block_g = |(g[i*BLOCK_SIZE +: BLOCK_SIZE] & 
                           {BLOCK_SIZE{1'b1}} << (BLOCK_SIZE-1));
            
            // Block carry computation
            assign carry_block[i+1] = block_g | (block_p & carry_block[i]);
            
            // Bit-level computation within each block
            for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : bit
                localparam bit_idx = i*BLOCK_SIZE + j;
                
                // Operand isolation for power optimization
                wire a_bit = (bit_idx < 64) ? A[bit_idx] : 1'b0;
                wire b_bit = (bit_idx < 64) ? B_comp[bit_idx] : 1'b0;
                
                // Propagate and generate
                assign p[bit_idx] = a_bit ^ b_bit;
                assign g[bit_idx] = a_bit & b_bit;
                
                // Carry computation (only for bits within block)
                wire carry_bit;
                if (j == 0) begin
                    assign carry_bit = carry_block[i];
                end else begin
                    assign carry_bit = g[bit_idx-1] | 
                                     (p[bit_idx-1] & ((j > 1) ? carry[bit_idx-1] : carry_block[i]));
                end
                
                // Result computation with conditional carry
                assign result[bit_idx] = p[bit_idx] ^ 
                                       ((bit_idx < 64) ? carry_bit : 1'b0);
                
                // Store carry for next bit (optimized sharing)
                if (j < BLOCK_SIZE-1) begin
                    assign carry[bit_idx] = carry_bit;
                end
            end
        end
    endgenerate

    /* Optimized Overflow Detection:
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Detected when sign bits show overflow pattern
     */
    wire a_sign = A[63];
    wire b_sign = B[63];
    wire r_sign = result[63];
    assign overflow = (a_sign ^ b_sign) & (a_sign ^ r_sign);

    /* Implementation Notes:
     * 1. Hierarchical carry-lookahead (4-bit blocks) reduces critical path
     * 2. Operand isolation and conditional carry reduce power consumption
     * 3. Shared logic between bits optimizes area
     * 4. Optimized overflow detection uses minimal gates
     */
endmodule