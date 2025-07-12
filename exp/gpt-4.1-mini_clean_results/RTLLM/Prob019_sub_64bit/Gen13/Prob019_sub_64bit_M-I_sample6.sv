module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement of B: ~B + 1
    wire [63:0] B_comp = ~B;

    // Internal wires for carry between blocks
    wire [8:0] block_carry;

    // Block propagate and generate signals (for 8 blocks)
    wire [7:0] block_P;
    wire [7:0] block_G;

    // Internal sums from each 8-bit CLA block
    wire [63:0] sum_internal;

    assign block_carry[0] = 1'b1; // carry-in = 1 for two's complement addition (A + ~B + 1)

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : CLA_BLOCKS
            cla_8bit cla8 (
                .A    (A[8*i +: 8]),
                .B    (B_comp[8*i +: 8]),
                .cin  (block_carry[i]),
                .sum  (sum_internal[8*i +: 8]),
                .P    (block_P[i]),
                .G    (block_G[i])
            );
        end
    endgenerate

    // Top-level carry lookahead for blocks
    cla_8block cla_top (
        .P   (block_P),
        .G   (block_G),
        .cin (block_carry[0]),
        .C   (block_carry[8:1])
    );

    assign result = sum_internal;

    // Overflow detection as before:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 8-bit Carry Lookahead Adder
// Inputs: A[7:0], B[7:0], carry-in
// Outputs: sum[7:0], block propagate P, block generate G
module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       P,
    output wire       G
);
    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals
    wire [8:0] c; // carry signals

    assign p = A ^ B;
    assign g = A & B;
    assign c[0] = cin;

    // Carry generation
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : bit_carry
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign sum = p ^ c[7:0];

    // Block propagate: P = p7 & p6 & ... & p0
    assign P = &p;

    // Block generate: G = g7 | (p7 & g6) | (p7&p6 & g5) | ... etc.
    // We implement it with standard CLA logic
    assign G = g[7] |
               (p[7] & g[6]) |
               (p[7] & p[6] & g[5]) |
               (p[7] & p[6] & p[5] & g[4]) |
               (p[7] & p[6] & p[5] & p[4] & g[3]) |
               (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) |
               (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
               (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]);

endmodule


// Top-level CLA for 8 blocks
// Inputs: 8 block propagate (P) and generate (G) signals, carry-in cin
// Outputs: 7 carry signals between blocks in C[7:1]
// (C[0] = cin is input)
module cla_8block (
    input  wire [7:0] P,
    input  wire [7:0] G,
    input  wire       cin,
    output wire [7:1] C
);
    wire c0 = cin;

    // Generate carries C[1] to C[7] for block boundaries
    // C[i] = G[i-1] | (P[i-1] & C[i-1])
    assign C[1] = G[0] | (P[0] & c0);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    // The carry-out of the last block would be computed by next-level logic if needed.
    // Not needed here.

endmodule