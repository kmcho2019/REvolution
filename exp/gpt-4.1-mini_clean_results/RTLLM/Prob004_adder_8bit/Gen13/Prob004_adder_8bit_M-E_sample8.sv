// Single-bit full adder module with generate and propagate outputs
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout,
    output wire g,   // generate = a & b
    output wire p    // propagate = a ^ b
);
    assign g    = a & b;
    assign p    = a ^ b;
    assign sum  = p ^ cin;
    assign cout = g | (p & cin);
endmodule

// 4-bit adder module with outputs for group generate and propagate
module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout,
    output wire       G,    // group generate
    output wire       P     // group propagate
);
    wire [3:0] g, p;
    wire [3:0] c;

    // Instantiate four full adders in ripple with carry lines c
    bit_full_adder fa0 (a[0], b[0], cin, sum[0], c[0], g[0], p[0]);
    bit_full_adder fa1 (a[1], b[1], c[0], sum[1], c[1], g[1], p[1]);
    bit_full_adder fa2 (a[2], b[2], c[1], sum[2], c[2], g[2], p[2]);
    bit_full_adder fa3 (a[3], b[3], c[2], sum[3], c[3], g[3], p[3]);

    assign cout = c[3];

    // Compute group propagate and generate for 4-bit block
    assign P = p[3] & p[2] & p[1] & p[0];
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

// 8-bit adder module using two 4-bit adders with carry-lookahead between them
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire c4;         // carry between lower and upper 4 bits
    wire G0, P0;     // lower 4-bit group generate and propagate
    wire G1, P1;     // upper 4-bit group generate and propagate

    // Lower 4-bit adder (bits 0 to 3)
    adder_4bit lower4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(),   // not used directly here
        .G(G0),
        .P(P0)
    );

    // Carry into upper 4-bit adder using carry lookahead:
    // c4 = G0 + P0 * cin
    assign c4 = G0 | (P0 & cin);

    // Upper 4-bit adder (bits 4 to 7)
    adder_4bit upper4 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout),
        .G(G1),
        .P(P1)
    );
endmodule