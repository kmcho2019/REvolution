module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction as A + (~B + 1)
    wire cout;

    cla_64bit_sub cla_sub (
        .A    (A),
        .B    (B),
        .cin  (1'b1),   // Adding 1 for two's complement subtraction
        .sum  (result),
        .cout (cout)
    );

    // Overflow detection:
    // Overflow occurs when sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit subtractor implemented as A + (~B) + cin
// Hierarchical CLA with 4 blocks of 16 bits each.
// Top-level 4-bit CLA computes carries for block boundaries.
// Each 16-bit block computes local sum and carry using ripple carry within block for simplicity.
module cla_64bit_sub (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    // Internal inversion of B for subtraction
    wire [63:0] B_comp = ~B;

    // Generate and propagate signals for all bits
    wire [63:0] P = A ^ B_comp;  // propagate = A xor B'
    wire [63:0] G = A & B_comp;  // generate  = A and B'

    // Block-level propagate and generate signals for 16-bit blocks
    wire [3:0] P_block;
    wire [3:0] G_block;

    genvar i, j;

    generate
        for (i = 0; i < 4; i = i + 1) begin : block_pg
            // For block i, bits [16*i +: 16]
            // Block propagate = AND of P bits in the block
            assign P_block[i] = &P[i*16 +:16];

            // Block generate:
            // G_block[i] = G[highest bit in block] 
            // OR (P[highest bit] AND G[bit below]) ... cascading down
            // We compute it using a ripple-like carry within block for generate:
            // G_block[i] = G[15+16*i] | (P[15+16*i] & G[14+16*i]) | ... recursively.
            // For synthesis clarity, implement a small generate chain for block generate:
            wire g_block_tmp [15:0];
            assign g_block_tmp[0] = G[i*16];
            for (j = 1; j < 16; j = j + 1) begin : gen_chain
                assign g_block_tmp[j] = G[i*16 + j] | (P[i*16 + j] & g_block_tmp[j-1]);
            end
            assign G_block[i] = g_block_tmp[15];
        end
    endgenerate

    // Top-level carry signals for each block boundary: C_block[0..4]
    wire [4:0] C_block;
    assign C_block[0] = cin;

    // Top-level 4-bit CLA for block carries:
    // Compute carries into each block from block G/P:
    // Use classic CLA formula for 4-bit:
    // C_block[i+1] = G_block[i] | (P_block[i] & C_block[i])
    generate
        for (i = 0; i < 4; i = i + 1) begin : top_carry
            assign C_block[i+1] = G_block[i] | (P_block[i] & C_block[i]);
        end
    endgenerate

    // Within each 16-bit block compute internal carries and sums
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_sum
            wire [15:0] p_blk = P[i*16 +:16];
            wire [15:0] g_blk = G[i*16 +:16];
            wire [16:0] c_blk;

            assign c_blk[0] = C_block[i];

            // Ripple carry within block: C[i+1] = G[i] | (P[i] & C[i])
            for (j = 0; j < 16; j = j + 1) begin : carry_within_block
                assign c_blk[j+1] = g_blk[j] | (p_blk[j] & c_blk[j]);
            end

            // sum bits = p ^ c (carry in at that bit)
            for (j = 0; j < 16; j = j + 1) begin : sum_bits
                assign sum[i*16 + j] = p_blk[j] ^ c_blk[j];
            end
        end
    endgenerate

    assign cout = C_block[4];

endmodule