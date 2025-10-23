module adder_8bit_cla (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       P_block, // Group propagate
    output       G_block, // Group generate
    output       Cout
);
    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals
    wire [8:0] c; // carry signals

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = Cin;

    // Carry lookahead signals for each bit:
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    assign sum = p ^ c[7:0];

    assign Cout = c[8];

    // Group propagate: all bits propagate
    assign P_block = &p;

    // Group generate: block generates carry regardless of carry-in
    // G_block = g7 + p7g6 + p7p6g5 + ... + p7p6p5p4p3p2p1g0
    // To simplify, use recursive:
    wire g01, g02, g03, g04, g05, g06, g07;
    assign g01 = g[1] | (p[1] & g[0]);
    assign g02 = g[2] | (p[2] & g01);
    assign g03 = g[3] | (p[3] & g02);
    assign g04 = g[4] | (p[4] & g03);
    assign g05 = g[5] | (p[5] & g04);
    assign g06 = g[6] | (p[6] & g05);
    assign g07 = g[7] | (p[7] & g06);

    assign G_block = g07;
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire P_low, G_low, C_mid;
    wire P_high, G_high;

    // Instantiate lower 8-bit CLA
    adder_8bit_cla adder_lo (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .P_block(P_low),
        .G_block(G_low),
        .Cout() // Not used directly here
    );

    // Compute carry-in for high block with two-level CLA logic
    assign C_mid = G_low | (P_low & Cin);

    // Instantiate upper 8-bit CLA with calculated carry-in
    adder_8bit_cla adder_hi (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C_mid),
        .sum(y[15:8]),
        .P_block(P_high),
        .G_block(G_high),
        .Cout(Co)
    );
endmodule