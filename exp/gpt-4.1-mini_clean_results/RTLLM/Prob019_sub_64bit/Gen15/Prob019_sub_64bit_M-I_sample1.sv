module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement B once for subtraction (A + ~B + 1)
    wire [63:0] B_neg = ~B;

    // Bit-level propagate and generate
    wire [63:0] P = A ^ B_neg; // propagate
    wire [63:0] G = A & B_neg; // generate

    // Carry signals: carry[0] = 1 (carry-in for adding 1)
    wire [64:0] carry;
    assign carry[0] = 1'b1;

    // Hierarchical carry-lookahead for 64 bits in 4-bit blocks (16 blocks)
    // For each 4-bit block: compute block propagate (PG) and generate (GG)
    wire [15:0] block_PG; // block propagate
    wire [15:0] block_GG; // block generate

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : block4
            wire [3:0] p_block = P[i*4 +: 4];
            wire [3:0] g_block = G[i*4 +: 4];

            // Compute carries inside 4-bit block using carry-lookahead logic
            // carry_in for this block is carry[i*4]
            wire c1 = g_block[0] | (p_block[0] & carry[i*4]);
            wire c2 = g_block[1] | (p_block[1] & g_block[0]) | (p_block[1] & p_block[0] & carry[i*4]);
            wire c3 = g_block[2] | (p_block[2] & g_block[1]) | (p_block[2] & p_block[1] & g_block[0]) | (p_block[2] & p_block[1] & p_block[0] & carry[i*4]);
            wire c4 = g_block[3] | (p_block[3] & g_block[2]) | (p_block[3] & p_block[2] & g_block[1]) | (p_block[3] & p_block[2] & p_block[1] & g_block[0]) 
                      | (p_block[3] & p_block[2] & p_block[1] & p_block[0] & carry[i*4]);

            // Block propagate and generate signals
            assign block_PG[i] = &p_block;    // AND of all p bits in block
            assign block_GG[i] = c4;          // carry out of the block is block generate

            // Assign carry signals for bits inside the block
            // bit carry-in at bit k is carry[k]
            assign carry[i*4 + 1] = c1;
            assign carry[i*4 + 2] = c2;
            assign carry[i*4 + 3] = c3;
            assign carry[i*4 + 4] = c4;
        end
    endgenerate

    // Now compute carries between 4-bit blocks using carry-lookahead for 16 blocks
    // This requires computing carry between blocks 0..15
    // carry_in of block[i+1] = block_GG[i] | (block_PG[i] & carry_in_block[i])

    wire [16:0] block_carry;
    assign block_carry[0] = carry[0]; // initial carry-in = 1

    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : block_carry_chain
            assign block_carry[j+1] = block_GG[j] | (block_PG[j] & block_carry[j]);
        end
    endgenerate

    // After computing block-level carries, override carry at block boundaries to ensure consistency
    // carry[i*4] should equal block_carry[i]
    // We already used carry[i*4] inside each block; let's drive them to block_carry to enforce correctness

    // But carry[i*4] were inputs inside the block carry computations, so to be consistent,
    // update carry[i*4] with block_carry[i] before internal block carry calc?

    // Since carry[i*4] is used as input in block4 generate, this would be combinational loop if we assign again.

    // To avoid combinational loops, we separate the hierarchy:
    // Step 1: compute block_carry from carry[0]
    // Step 2: assign carry[i*4] = block_carry[i]
    // Step 3: compute intra-block carry based on carry[i*4]

    // We reorder code accordingly:

endmodule


// Improved module with proper hierarchical CLA that avoids combinational loop
module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_neg = ~B;

    // Bit propagate and generate
    wire [63:0] P = A ^ B_neg;
    wire [63:0] G = A & B_neg;

    // First-level carry block signals: 16 blocks of 4 bits
    wire [15:0] block_PG; // block propagate
    wire [15:0] block_GG; // block generate

    // Intermediate carries at block boundaries
    wire [16:0] block_carry; // carry in to each block, block_carry[0] = 1

    assign block_carry[0] = 1'b1;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : block_pg_gg
            wire [3:0] p_blk = P[i*4 +: 4];
            wire [3:0] g_blk = G[i*4 +: 4];

            // Block propagate = AND of all p bits
            assign block_PG[i] = &p_blk;

            // Block generate = c4 (carry-out of 4th bit)
            // Compute carry within 4-bit block for generate
            // c1 = g0 + p0*c0
            // c2 = g1 + p1*g0 + p1*p0*c0
            // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*c0
            // c4 = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*c0
            // For block generate, c0 = carry_in to block = unknown at this point, so express as:
            // GG = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*c0
            // So block_GG = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0
            wire g3 = g_blk[3], g2 = g_blk[2], g1 = g_blk[1], g0 = g_blk[0];
            wire p3 = p_blk[3], p2 = p_blk[2], p1 = p_blk[1], p0 = p_blk[0];
            assign block_GG[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Carry between blocks
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : carry_between_blocks
            assign block_carry[j+1] = block_GG[j] | (block_PG[j] & block_carry[j]);
        end
    endgenerate

    // Now generate full carry for each bit inside blocks using block_carry as carry-in

    wire [64:0] carry;
    assign carry[0] = block_carry[0];

    generate
        for (i = 0; i < 16; i = i + 1) begin : intra_block_carry
            wire [3:0] p_blk = P[i*4 +: 4];
            wire [3:0] g_blk = G[i*4 +: 4];
            wire c0 = block_carry[i];
            // carry[4*i + 1]
            assign carry[4*i + 1] = g_blk[0] | (p_blk[0] & c0);
            // carry[4*i + 2]
            assign carry[4*i + 2] = g_blk[1] | (p_blk[1] & g_blk[0]) | (p_blk[1] & p_blk[0] & c0);
            // carry[4*i + 3]
            assign carry[4*i + 3] = g_blk[2] | (p_blk[2] & g_blk[1]) | (p_blk[2] & p_blk[1] & g_blk[0]) | (p_blk[2] & p_blk[1] & p_blk[0] & c0);
            // carry[4*i + 4]
            assign carry[4*i + 4] = g_blk[3] | (p_blk[3] & g_blk[2]) | (p_blk[3] & p_blk[2] & g_blk[1]) | (p_blk[3] & p_blk[2] & p_blk[1] & g_blk[0]) 
                                | (p_blk[3] & p_blk[2] & p_blk[1] & p_blk[0] & c0);
        end
    endgenerate

    // Result bits = P XOR carry-in for each bit (sum)
    assign result = P ^ carry[63:0];

    // Overflow detection
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule