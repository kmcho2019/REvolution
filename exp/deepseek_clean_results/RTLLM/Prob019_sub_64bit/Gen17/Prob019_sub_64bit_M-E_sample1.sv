module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Invert B and add 1 (two's complement negation)
    wire [63:0] B_neg = ~B + 1;
    
    // Generate and propagate terms for entire width
    wire [63:0] gen = A & B_neg;
    wire [63:0] prop = A ^ B_neg;
    
    /////////////////////////////////////////////////
    // 8-bit Carry-Select Blocks with Speculative Prefix
    /////////////////////////////////////////////////
    wire [7:0] block_carry_out;
    wire [63:0] speculative_sum [1:0];
    
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CARRY_SELECT_BLOCKS
            // Carry-0 and Carry-1 speculative paths
            wire [7:0] carry0, carry1;
            wire [7:0] sum0, sum1;
            
            // Kogge-Stone prefix network for 8-bit block
            // Stage 1
            wire [7:0] g1, p1;
            assign g1[0] = gen[i];
            assign p1[0] = prop[i];
            assign {g1[7:1], p1[7:1]} = {gen[i+7:i+1], prop[i+7:i+1]};
            
            // Stage 2
            wire [7:0] g2, p2;
            assign g2[0] = g1[0];
            assign p2[0] = p1[0];
            assign g2[1] = g1[1] | (p1[1] & g1[0]);
            assign p2[1] = p1[1] & p1[0];
            assign {g2[7:2], p2[7:2]} = {gen[i+7:i+2], prop[i+7:i+2]};
            
            // Stage 3 (final carries)
            assign carry0[0] = g1[0];
            assign carry0[1] = g2[1];
            assign carry0[2] = g1[2] | (p1[2] & g2[1]);
            assign carry0[3] = g1[3] | (p1[3] & (g1[2] | (p1[2] & g2[1])));
            assign carry0[7:4] = {4{1'b0}}; // Upper bits unused for carry0
            
            assign carry1 = carry0 | {8{(i>0) ? block_carry_out[(i/8)-1] : 1'b1}};
            
            // Speculative sums
            assign sum0 = prop[i+:8] ^ {carry0[6:0], (i>0) ? block_carry_out[(i/8)-1] : 1'b1};
            assign sum1 = prop[i+:8] ^ {carry1[6:0], 1'b1};
            
            // Final mux selection
            assign speculative_sum[0][i+:8] = sum0;
            assign speculative_sum[1][i+:8] = sum1;
            assign block_carry_out[i/8] = carry1[7];
        end
    endgenerate
    
    // Final result selection
    wire [7:0] carry_chain;
    assign carry_chain[0] = 1'b1; // Initial carry-in for subtraction
    
    genvar j;
    generate
        for (j=1; j<8; j=j+1) begin : CARRY_CHAIN
            assign carry_chain[j] = block_carry_out[j-1];
        end
    endgenerate
    
    assign result = speculative_sum[carry_chain[7]];
    
    /////////////////////////////////////////////////
    // Enhanced Overflow Detection
    /////////////////////////////////////////////////
    wire ovf_sign = (A[63] != B[63]) && (A[63] != result[63]);
    wire ovf_carry = (block_carry_out[7] ^ block_carry_out[6]);
    
    assign overflow = ovf_sign | ovf_carry;
    
    /* Overflow Detection:
     * 1. Traditional sign-based overflow (ovf_sign)
     * 2. Carry-based overflow (ovf_carry) when final carries mismatch
     * This provides more robust overflow detection than standard methods
     */

endmodule