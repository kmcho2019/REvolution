// 8-bit CLA block: produces 8 sum bits and group generate/propagate signals
module cla_8bit(
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] S,
    output       G,  // Group generate
    output       P   // Group propagate
);
    wire [7:0] P_bit = A ^ B;  // propagate bits
    wire [7:0] G_bit = A & B;  // generate bits

    // Carry signals inside 8-bit block
    wire [8:0] C;
    assign C[0] = Cin;

    // Compute carries using carry-lookahead logic
    // C[i+1] = G[i] | (P[i] & C[i])
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : carry_loop
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[7:0];

    // Group propagate: all bits propagate
    assign P = &P_bit;

    // Group generate: generated inside block or propagate all and Cin generate
    assign G = G_bit[7] |
               (P_bit[7] & G_bit[6]) |
               (P_bit[7] & P_bit[6] & G_bit[5]) |
               (P_bit[7] & P_bit[6] & P_bit[5] & G_bit[4]) |
               (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & G_bit[3]) |
               (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & G_bit[2]) |
               (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) |
               (P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
endmodule

// 4-bit CLA carry generator for inter-block carry propagation
module cla_4bit_carry(
    input  [3:0] G,   // Generate from 8-bit blocks
    input  [3:0] P,   // Propagate from 8-bit blocks
    input        Cin,
    output [4:0] C    // C[0] = Cin, C[4] = final Cout
);
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
endmodule

// Top-level 32-bit adder with hierarchical 4 x 8-bit CLAs and 4-bit CLA carry propagation
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Break inputs into 4 blocks of 8 bits each (remember 1-based indexing)
    wire [7:0] A_blk [3:0];
    wire [7:0] B_blk [3:0];
    wire [7:0] S_blk [3:0];
    wire       G_blk [3:0];
    wire       P_blk [3:0];

    assign A_blk[0] = A[8:1];
    assign A_blk[1] = A[16:9];
    assign A_blk[2] = A[24:17];
    assign A_blk[3] = A[32:25];

    assign B_blk[0] = B[8:1];
    assign B_blk[1] = B[16:9];
    assign B_blk[2] = B[24:17];
    assign B_blk[3] = B[32:25];

    wire [4:0] C;  // carry signals between blocks, C[0]=0 input carry

    cla_4bit_carry clc4 (
        .G(G_blk),
        .P(P_blk),
        .Cin(1'b0),
        .C(C)
    );

    genvar idx;
    generate
        for (idx=0; idx<4; idx=idx+1) begin : cla8_blocks
            cla_8bit cla8 (
                .A(A_blk[idx]),
                .B(B_blk[idx]),
                .Cin(C[idx]),
                .S(S_blk[idx]),
                .G(G_blk[idx]),
                .P(P_blk[idx])
            );
        end
    endgenerate

    assign S[8:1]   = S_blk[0];
    assign S[16:9]  = S_blk[1];
    assign S[24:17] = S_blk[2];
    assign S[32:25] = S_blk[3];

    assign C32 = C[4];
endmodule