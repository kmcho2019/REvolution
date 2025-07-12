module cla_8bit(
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       Cout,
    output       P, // block propagate
    output       G  // block generate
);
    wire [8:1] p, g;
    wire [8:0] c;

    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 8; i = i + 1) begin : pg_gen
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Internal carry computation within 8-bit block
    // CLA style carry calculation
    // c[i] = g[i] | (p[i] & c[i-1])
    generate
        for (i = 1; i <= 8; i = i + 1) begin : carry_gen
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    generate
        for (i = 1; i <= 8; i = i + 1) begin : sum_gen
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    assign Cout = c[8];

    // Block propagate: all bit propagates ANDed
    assign P = &p[8:1];

    // Block generate: carry generate independent of carry-in
    // Calculated by simulating carry with Cin=0
    wire [8:0] c0;
    assign c0[0] = 1'b0;
    generate
        for (i = 1; i <= 8; i = i + 1) begin : carry0_gen
            assign c0[i] = g[i] | (p[i] & c0[i-1]);
        end
    endgenerate
    assign G = c0[8];
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Wires for block signals
    wire [3:0] P_block, G_block;    // block propagate/generate for each 8-bit block
    wire [4:0] c_block;             // carries between blocks (c_block[0] = 0)

    assign c_block[0] = 1'b0;

    // Instantiate 4 instances of 8-bit CLA for 32 bits
    cla_8bit cla0(
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(c_block[0]),
        .S(S[8:1]),
        .Cout(),
        .P(P_block[0]),
        .G(G_block[0])
    );

    cla_8bit cla1(
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(c_block[1]),
        .S(S[16:9]),
        .Cout(),
        .P(P_block[1]),
        .G(G_block[1])
    );

    cla_8bit cla2(
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(c_block[2]),
        .S(S[24:17]),
        .Cout(),
        .P(P_block[2]),
        .G(G_block[2])
    );

    cla_8bit cla3(
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(c_block[3]),
        .S(S[32:25]),
        .Cout(C32),
        .P(P_block[3]),
        .G(G_block[3])
    );

    // Carry-lookahead logic between blocks (4 blocks)
    // Using block propagate and generate, compute carry for each block
    // c_block[i] = G_block[i-1] | (P_block[i-1] & c_block[i-1])

    // Calculate c_block[1..4]
    genvar j;
    generate
        for (j = 1; j <= 4; j = j + 1) begin : block_carry_gen
            assign c_block[j] = G_block[j-1] | (P_block[j-1] & c_block[j-1]);
        end
    endgenerate
endmodule