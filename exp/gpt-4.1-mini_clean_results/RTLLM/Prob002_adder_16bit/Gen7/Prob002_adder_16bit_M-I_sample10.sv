module adder_8bit_cla (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co,
    output       P,    // block propagate
    output       G     // block generate
);
    wire [7:0] p, g;       // propagate and generate
    wire [7:1] c;          // internal carries

    // Generate propagate and generate signals for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic inside 8-bit block
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);

    assign Co   = g[7] | (p[7] & c[7]);

    // Sum bits
    assign y[0] = p[0] ^ Cin;
    assign y[1] = p[1] ^ c[1];
    assign y[2] = p[2] ^ c[2];
    assign y[3] = p[3] ^ c[3];
    assign y[4] = p[4] ^ c[4];
    assign y[5] = p[5] ^ c[5];
    assign y[6] = p[6] ^ c[6];
    assign y[7] = p[7] ^ c[7];

    // Block propagate and generate signals for hierarchical CLA
    assign P = &p;               // Block propagate = AND of all bit propagates
    assign G = g[7] | (p[7] & g[6]) | (p[7]&p[6]&g[5]) | (p[7]&p[6]&p[5]&g[4]) 
             | (p[7]&p[6]&p[5]&p[4]&g[3]) | (p[7]&p[6]&p[5]&p[4]&p[3]&g[2]) 
             | (p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&g[1]) 
             | (p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0]);
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire [7:0] sum_low, sum_high;
    wire       P0, G0;   // propagate and generate for lower 8-bit block
    wire       P1, G1;   // propagate and generate for upper 8-bit block
    wire       c1;       // carry between blocks

    // Instantiate lower 8-bit CLA
    adder_8bit_cla u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(),
        .P(P0),
        .G(G0)
    );

    // Instantiate upper 8-bit CLA
    // Cin is c1 computed via block-level carry lookahead
    adder_8bit_cla u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .y(sum_high),
        .Co(Co),
        .P(P1),
        .G(G1)
    );

    // Block level carry lookahead for carry into upper 8-bit block
    // c1 = G0 + P0 * Cin
    assign c1 = G0 | (P0 & Cin);

    assign y = {sum_high, sum_low};
endmodule