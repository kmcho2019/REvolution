module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] B_neg = ~B; // bitwise complement of B

    // Carry signals between blocks
    wire [8:0] carry;

    assign carry[0] = 1'b1; // initial carry-in for subtraction (adding 1)

    // 8 blocks of 8 bits each
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : block_add
            cla_8bit cla8 (
                .A   (A[8*i +: 8]),
                .B   (B_neg[8*i +: 8]),
                .cin (carry[i]),
                .sum (result[8*i +: 8]),
                .cout(carry[i+1]),
                .P   (), // unused for block-level carry logic here
                .G   ()
            );
        end
    endgenerate

    // Extract propagate and generate per block for carry lookahead
    // To do this, we compute block-level P and G from each 8-bit CLA

    wire [7:0] P_block, G_block;

    generate
        for (i = 0; i < 8; i = i + 1) begin : pg_block_calc
            pg_8bit pg8 (
                .A  (A[8*i +: 8]),
                .B  (B_neg[8*i +: 8]),
                .P  (P_block[i]),
                .G  (G_block[i])
            );
        end
    endgenerate

    // Top-level carry lookahead for 8 blocks
    carry_lookahead_8block carry_lookahead8 (
        .P      (P_block),
        .G      (G_block),
        .cin    (1'b1),
        .carry  (carry)
    );

    // Overflow detection for subtraction A - B:
    // Overflow if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 8-bit CLA block: sum and carry-out, optional P and G outputs for block-level carry
module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout,
    output wire       P,  // block propagate (all bits propagate)
    output wire       G   // block generate
);
    wire [7:0] p, g;
    wire [8:0] c;

    assign c[0] = cin;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : bit_cla
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
            assign c[i+1] = g[i] | (p[i] & c[i]);
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign cout = c[8];
    assign P = &p;                 // block propagate = AND of all bit propagates
    assign G = g[7] | (p[7] & g[6]) | (p[7]&p[6]&g[5]) | (p[7]&p[6]&p[5]&g[4]) |
               (p[7]&p[6]&p[5]&p[4]&g[3]) | (p[7]&p[6]&p[5]&p[4]&p[3]&g[2]) |
               (p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&g[1]) |
               (p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0]);
endmodule


// Simplified module to compute propagate and generate for 8-bit block (without carry chains)
module pg_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire       P, // block propagate
    output wire       G  // block generate
);
    wire [7:0] p, g;

    assign p = A ^ B;
    assign g = A & B;

    assign P = &p;

    assign G = g[7] | (p[7] & g[6]) | (p[7]&p[6] & g[5]) | (p[7]&p[6]&p[5] & g[4]) |
               (p[7]&p[6]&p[5]&p[4] & g[3]) | (p[7]&p[6]&p[5]&p[4]&p[3] & g[2]) |
               (p[7]&p[6]&p[5]&p[4]&p[3]&p[2] & g[1]) |
               (p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1] & g[0]);
endmodule


// Carry lookahead logic for 8 blocks (carry[0]..carry[8])
module carry_lookahead_8block (
    input  wire [7:0] P,   // block propagate signals
    input  wire [7:0] G,   // block generate signals
    input  wire       cin, // initial carry-in
    output wire [8:0] carry // carry outputs for each block (carry[0] = cin)
);
    assign carry[0] = cin;
    assign carry[1] = G[0] | (P[0] & carry[0]);
    assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & carry[0]);
    assign carry[3] = G[2] | (P[2] & G[1]) | (P[2]&P[1] & G[0]) | (P[2]&P[1]&P[0] & carry[0]);
    assign carry[4] = G[3] | (P[3] & G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) |
                      (P[3]&P[2]&P[1]&P[0]&carry[0]);
    assign carry[5] = G[4] | (P[4] & G[3]) | (P[4]&P[3]&G[2]) | (P[4]&P[3]&P[2]&G[1]) |
                      (P[4]&P[3]&P[2]&P[1]&G[0]) |
                      (P[4]&P[3]&P[2]&P[1]&P[0]&carry[0]);
    assign carry[6] = G[5] | (P[5] & G[4]) | (P[5]&P[4]&G[3]) | (P[5]&P[4]&P[3]&G[2]) |
                      (P[5]&P[4]&P[3]&P[2]&G[1]) |
                      (P[5]&P[4]&P[3]&P[2]&P[1]&G[0]) |
                      (P[5]&P[4]&P[3]&P[2]&P[1]&P[0]&carry[0]);
    assign carry[7] = G[6] | (P[6] & G[5]) | (P[6]&P[5]&G[4]) | (P[6]&P[5]&P[4]&G[3]) |
                      (P[6]&P[5]&P[4]&P[3]&G[2]) |
                      (P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) |
                      (P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&G[0]) |
                      (P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&P[0]&carry[0]);
    assign carry[8] = G[7] | (P[7] & G[6]) | (P[7]&P[6]&G[5]) | (P[7]&P[6]&P[5]&G[4]) |
                      (P[7]&P[6]&P[5]&P[4]&G[3]) |
                      (P[7]&P[6]&P[5]&P[4]&P[3]&G[2]) |
                      (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) |
                      (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&G[0]) |
                      (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&P[0]&carry[0]);
endmodule