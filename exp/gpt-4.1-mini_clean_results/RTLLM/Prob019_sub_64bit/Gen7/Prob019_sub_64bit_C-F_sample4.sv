module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Two's complement subtraction: A - B = A + (~B + 1)
    wire [63:0] B_inv = ~B;

    // We'll implement a hybrid carry structure:
    // - Divide 64 bits into 16 blocks of 4 bits.
    // - Each block computes sum and block generate/propagate signals with carry-lookahead.
    // - Between blocks, carries ripple (carry rippling between blocks only).
    // This reduces critical path and area compared to full 64-bit carry-lookahead.

    // Intermediate signals:
    wire [15:0] block_P; // block propagate
    wire [15:0] block_G; // block generate
    wire [16:0] block_carry; // carries between blocks: block_carry[0] = initial carry_in = 1 for +1
    
    assign block_carry[0] = 1'b1; // carry-in for two's complement addition (+1)

    genvar blk;
    generate
        for (blk = 0; blk < 16; blk = blk + 1) begin : block4_adder_gen
            // Extract 4 bits of A and B_inv for this block
            wire [3:0] A_block = A[blk*4 +: 4];
            wire [3:0] B_block = B_inv[blk*4 +: 4];
            wire       cin = block_carry[blk];
            wire [3:0] sum_block;
            wire       cout_block;
            wire       P_block; // propagate for block
            wire       G_block; // generate for block

            // 4-bit carry-lookahead adder
            carry_lookahead_4bit_adder u4bit (
                .A   (A_block),
                .B   (B_block),
                .cin (cin),
                .sum (sum_block),
                .cout(cout_block),
                .P   (P_block),
                .G   (G_block)
            );

            assign result[blk*4 +: 4] = sum_block;
            assign block_P[blk] = P_block;
            assign block_G[blk] = G_block;
            assign block_carry[blk+1] = cout_block;
        end
    endgenerate

    // Overflow detection (from original examples):
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule

// 4-bit carry-lookahead adder for one block
// Inputs: A[3:0], B[3:0], carry-in
// Outputs: sum[3:0], carry-out, block propagate (P), block generate (G)
//
// Block propagate = all bits propagate
// Block generate = block generates carry-out regardless of carry-in
module carry_lookahead_4bit_adder (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout,
    output wire       P, // block propagate
    output wire       G  // block generate
);
    wire [3:0] p; // propagate signals for bits
    wire [3:0] g; // generate signals for bits
    wire [4:0] c; // carries

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead equations:
    // c[1] = g[0] | (p[0] & c[0])
    // c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0])
    // c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0])
    // c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0])

    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];

    // Block propagate: all bit propagates are 1 (means carry_in propagates through entire block)
    assign P = &p; // AND of all p bits

    // Block generate: block generates carry regardless of carry_in
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule