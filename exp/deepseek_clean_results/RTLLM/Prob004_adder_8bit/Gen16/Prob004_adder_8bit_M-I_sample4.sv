/**
 * 8-bit Carry Lookahead Adder - Optimized Implementation
 * Uses 4-bit CLA blocks with ripple carry between blocks
 * Provides better timing performance than ripple-carry adder
 */
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate and Propagate signals for each bit
    wire [7:0] g, p;
    assign g = a & b;  // Generate
    assign p = a | b;  // Propagate

    // Carry computation for 4-bit blocks
    wire [1:0] block_carry;
    wire [1:0] block_g, block_p;

    // First 4-bit block (bits 3:0)
    assign block_g[0] = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & g[0])))));
    assign block_p[0] = p[3] & p[2] & p[1] & p[0];
    assign block_carry[0] = g[0] | (p[0] & cin);
    assign block_carry[1] = g[1] | (p[1] & block_carry[0]);
    assign block_carry[2] = g[2] | (p[2] & block_carry[1]);
    assign block_carry[3] = g[3] | (p[3] & block_carry[2]);

    // Second 4-bit block (bits 7:4)
    wire c4 = block_g[0] | (block_p[0] & cin);
    assign block_g[1] = g[7] | (p[7] & (g[6] | (p[6] & (g[5] | (p[5] & g[4])))));
    assign block_p[1] = p[7] & p[6] & p[5] & p[4];
    assign block_carry[4] = g[4] | (p[4] & c4);
    assign block_carry[5] = g[5] | (p[5] & block_carry[4]);
    assign block_carry[6] = g[6] | (p[6] & block_carry[5]);
    assign block_carry[7] = g[7] | (p[7] & block_carry[6]);

    // Final carry out
    assign cout = block_g[1] | (block_p[1] & c4);

    // Sum computation
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ block_carry[0];
    assign sum[2] = a[2] ^ b[2] ^ block_carry[1];
    assign sum[3] = a[3] ^ b[3] ^ block_carry[2];
    assign sum[4] = a[4] ^ b[4] ^ c4;
    assign sum[5] = a[5] ^ b[5] ^ block_carry[4];
    assign sum[6] = a[6] ^ b[6] ^ block_carry[5];
    assign sum[7] = a[7] ^ b[7] ^ block_carry[6];

endmodule