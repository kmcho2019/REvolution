module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Invert B once for subtraction
    wire [63:0] B_comp = ~B;

    // Carry signals between 16-bit blocks
    wire [4:0] carry;  // 4 blocks + 1 carry out
    assign carry[0] = 1'b1; // cin = 1 for subtraction (+1 in two's complement)

    // Instantiate four 16-bit CLA blocks
    wire [15:0] sum_block [3:0];
    wire [3:0]  P_block;  // block propagate
    wire [3:0]  G_block;  // block generate

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla16_blocks
            cla_16bit_block cla16 (
                .A    (A[i*16 +: 16]),
                .B    (B_comp[i*16 +: 16]),
                .cin  (carry[i]),
                .sum  (sum_block[i]),
                .P    (P_block[i]),
                .G    (G_block[i]),
                .cout ()
            );
        end
    endgenerate

    // 4-bit block carry lookahead to compute carry[1]..carry[4]
    cla_4bit_block cla4 (
        .P    (P_block),
        .G    (G_block),
        .cin  (carry[0]),
        .cout (carry[4:1])
    );

    // Assemble result from sum blocks
    assign result = {sum_block[3], sum_block[2], sum_block[1], sum_block[0]};

    // Overflow detection (signed overflow):
    // Overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit CLA block module:
// Inputs: 16-bit A, B (B is complemented already), carry-in cin
// Outputs: 16-bit sum, block propagate (P), block generate (G), carry out cout
module cla_16bit_block (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        P,
    output wire        G,
    output wire        cout
);
    wire [15:0] P_bit; // propagate bits
    wire [15:0] G_bit; // generate bits
    wire [16:0] C;     // carry signals

    assign C[0] = cin;

    // Compute bit propagate and generate signals
    assign P_bit = A ^ B;
    assign G_bit = A & B;

    // Compute carries with carry-lookahead logic
    // Carry[i+1] = G[i] | (P[i] & Carry[i])
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_logic
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    // Sum bits
    assign sum = P_bit ^ C[15:0];
    assign cout = C[16];

    // Block propagate: all P_bit ANDed
    assign P = &P_bit;

    // Block generate: G[15] OR (P[15] & G[14]) OR ... (hierarchical):
    // Implemented via recursive logic:
    wire [15:0] g_and_p;

    assign g_and_p[0] = G_bit[0];
    generate
        for (i = 1; i < 16; i = i + 1) begin : gen_block_G
            assign g_and_p[i] = G_bit[i] | (P_bit[i] & g_and_p[i-1]);
        end
    endgenerate

    assign G = g_and_p[15];
endmodule


// 4-bit CLA block for block-level carry lookahead:
// Inputs: 4-bit P and G arrays, carry-in cin
// Outputs: carry-out signals cout[4:1]
module cla_4bit_block (
    input  wire [3:0] P,
    input  wire [3:0] G,
    input  wire       cin,
    output wire [3:1] cout
);
    // Carry lookahead logic for 4-bit block:
    // C1 = G0 + P0*cin
    // C2 = G1 + P1*G0 + P1*P0*cin
    // C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*cin

    assign cout[1] = G[0] | (P[0] & cin);
    assign cout[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign cout[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
    // cout[4] is carry-out of entire 64-bit adder, not needed here, so left out.
endmodule