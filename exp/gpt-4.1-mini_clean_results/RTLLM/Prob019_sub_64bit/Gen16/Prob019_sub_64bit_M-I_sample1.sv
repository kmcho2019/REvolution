module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement of B: ~B + 1
    wire [63:0] B_comp = ~B;

    // Perform A + (~B + 1)
    wire cout;
    cla_64bit cla_sub (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),   // Adding 1 for two's complement
        .sum (result),
        .cout(cout)
    );

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// Hierarchical 64-bit Carry Lookahead Adder (CLA)
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [7:0] block_carry;       // Carry out from each 8-bit block (except last)
    wire [7:0] block_p, block_g;  // Propagate and generate for each 8-bit block
    wire [63:0] P, G;             // Bit-level propagate/generate
    wire [64:0] C;                // Carry signals for bits

    assign C[0] = cin;

    // Compute bit-level propagate and generate signals
    assign P = A ^ B;  // propagate
    assign G = A & B;  // generate

    genvar i;
    generate
        // Compute per-block propagate (all bits propagate) and generate (carry generate within block)
        for (i = 0; i < 8; i = i + 1) begin : block_pg
            wire [7:0] p_bits = P[i*8 +: 8];
            wire [7:0] g_bits = G[i*8 +: 8];

            // Block propagate = AND of all propagate bits in block
            assign block_p[i] = &p_bits;

            // Block generate = generate carry within the block or from earlier carry
            // Use carry lookahead logic for block generate:
            // G_block = G7 + (P7*G6) + (P7*P6*G5) + ... + (P7*...*P0*Cin)
            // Implemented as a ripple carry on generate signals within the block to compute block_g[i]
            wire g0 = g_bits[0];
            wire g1 = g_bits[1] | (p_bits[1] & g0);
            wire g2 = g_bits[2] | (p_bits[2] & g1);
            wire g3 = g_bits[3] | (p_bits[3] & g2);
            wire g4 = g_bits[4] | (p_bits[4] & g3);
            wire g5 = g_bits[5] | (p_bits[5] & g4);
            wire g6 = g_bits[6] | (p_bits[6] & g5);
            wire g7 = g_bits[7] | (p_bits[7] & g6);

            assign block_g[i] = g7;
        end
    endgenerate

    // Compute block-level carries using block propagate and generate signals
    // This forms a small 8-bit CLA on the blocks
    wire [8:0] block_C;
    assign block_C[0] = cin;
    genvar b;
    generate
        for (b = 0; b < 8; b = b + 1) begin : block_carry_compute
            // block_C[i+1] = block_g[i] | (block_p[i] & block_C[i])
            assign block_C[b+1] = block_g[b] | (block_p[b] & block_C[b]);
        end
    endgenerate

    // Compute internal carries within each 8-bit block using block carry-in from block_C
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_carry_calc
            wire cin_block = block_C[i];
            wire [7:0] p_bits = P[i*8 +: 8];
            wire [7:0] g_bits = G[i*8 +: 8];

            // C within block
            // C[j+1] = G[j] | (P[j] & C[j])
            // First carry in is cin_block, then propagate sequentially within block
            // This is fast because blocks are small (8 bits)

            assign C[i*8 + 1] = g_bits[0] | (p_bits[0] & cin_block);
            assign C[i*8 + 2] = g_bits[1] | (p_bits[1] & C[i*8 + 1]);
            assign C[i*8 + 3] = g_bits[2] | (p_bits[2] & C[i*8 + 2]);
            assign C[i*8 + 4] = g_bits[3] | (p_bits[3] & C[i*8 + 3]);
            assign C[i*8 + 5] = g_bits[4] | (p_bits[4] & C[i*8 + 4]);
            assign C[i*8 + 6] = g_bits[5] | (p_bits[5] & C[i*8 + 5]);
            assign C[i*8 + 7] = g_bits[6] | (p_bits[6] & C[i*8 + 6]);
            assign C[i*8 + 8] = g_bits[7] | (p_bits[7] & C[i*8 + 7]);
        end
    endgenerate

    // Sum bits calculation: sum[i] = P[i] ^ C[i]
    assign sum = P ^ C[63:0];
    assign cout = C[64];
endmodule