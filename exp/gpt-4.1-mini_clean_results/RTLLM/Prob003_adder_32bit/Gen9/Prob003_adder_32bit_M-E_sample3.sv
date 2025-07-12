module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       P,   // block propagate
    output       G,   // block generate
    output       Cout
);
    wire [3:0] P_bit = A ^ B;     // propagate per bit
    wire [3:0] G_bit = A & B;     // generate per bit
    wire [4:0] C;

    assign C[0] = Cin;
    // Carry equations inside 4-bit block
    assign C[1] = G_bit[0] | (P_bit[0] & C[0]);
    assign C[2] = G_bit[1] | (P_bit[1] & C[1]);
    assign C[3] = G_bit[2] | (P_bit[2] & C[2]);
    assign C[4] = G_bit[3] | (P_bit[3] & C[3]);

    assign S = P_bit ^ C[3:0];
    assign Cout = C[4];

    // Block propagate is true if all bits propagate
    assign P = &P_bit;
    // Block generate is true if this block generates carry out regardless of Cin
    assign G = G_bit[3] |
               (P_bit[3] & G_bit[2]) |
               (P_bit[3] & P_bit[2] & G_bit[1]) |
               (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
endmodule

module carry_lookahead_8block(
    input  [7:0] P,    // propagate signals from each 4-bit block
    input  [7:0] G,    // generate signals from each 4-bit block
    input        Cin,
    output [7:0] C     // carry-in to each 4-bit block (C[0] = carry in to block0)
);
    wire [8:0] c_internal;
    assign c_internal[0] = Cin;

    // Carry lookahead logic for 8 blocks (c_internal[1] is carry into block 1 ...)
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : CLA_BLOCK_CARRY
            assign c_internal[i+1] = G[i] | (P[i] & c_internal[i]);
        end
    endgenerate

    assign C = c_internal[7:0];
endmodule

module adder_32bit(
    input  [32:1] A, // note: indexing from 32 down to 1 as per problem spec
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Re-index inputs to zero-based internally for simpler bit slicing
    wire [31:0] A_int = A[32:1];
    wire [31:0] B_int = B[32:1];

    wire [7:0] P_block, G_block;  // block propagate and generate signals
    wire [7:0] carry4;            // carry inputs to each 4-bit block

    // Instantiate carry lookahead block for 8 blocks of 4 bits
    carry_lookahead_8block u_cla8 (
        .P(P_block),
        .G(G_block),
        .Cin(1'b0),
        .C(carry4)
    );

    genvar j;
    generate
        for (j=0; j<8; j=j+1) begin : GEN_4BIT_CLA_BLOCKS
            cla_4bit u_cla4 (
                .A(A_int[4*j +: 4]),
                .B(B_int[4*j +: 4]),
                .Cin(carry4[j]),
                .S(S[4*j+4:4*j+1]),
                .P(P_block[j]),
                .G(G_block[j]),
                .Cout()  // unused here
            );
        end
    endgenerate

    // Compute final carry-out C32 = carry out from last 4-bit block
    // For last block carry-out:
    wire [3:0] P_bit_last = A_int[31:28] ^ B_int[31:28];
    wire [3:0] G_bit_last = A_int[31:28] & B_int[31:28];
    wire [4:0] c_last;

    assign c_last[0] = carry4[7];
    assign c_last[1] = G_bit_last[0] | (P_bit_last[0] & c_last[0]);
    assign c_last[2] = G_bit_last[1] | (P_bit_last[1] & c_last[1]);
    assign c_last[3] = G_bit_last[2] | (P_bit_last[2] & c_last[2]);
    assign c_last[4] = G_bit_last[3] | (P_bit_last[3] & c_last[3]);

    assign C32 = c_last[4];
endmodule