module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] sum,
    output       Cout,
    output       P,      // Group propagate
    output       G       // Group generate
);
    wire [3:0] p, g;
    wire [4:0] c;

    assign p = a ^ b;      // bitwise propagate
    assign g = a & b;      // bitwise generate
    assign c[0] = Cin;

    // Compute internal carries using carry-lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                  (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum = p ^ c[3:0];   // sum bits
    assign Cout = c[4];

    // Group propagate and generate
    assign P = &p;             // all propagate bits are 1
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule


module cla_4block (
    input        Cin,
    input  [3:0] P,  // Group propagate for each 4-bit block
    input  [3:0] G,  // Group generate for each 4-bit block
    output [3:0] c   // Carry-in to each 4-bit block (c[0]=Cin)
);
    // Carry lookahead for the 4 blocks
    assign c[0] = Cin;
    assign c[1] = G[0] | (P[0] & c[0]);
    assign c[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c[0]);
    assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c[0]);
    // Note: c[4] is the carry-out from the highest block, not needed here
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire [3:0] P, G;       // Group propagate and generate from each 4-bit adder
    wire [3:0] c_block;    // Carry-in for each 4-bit block
    wire       cout_blocks[3:0]; // Carry-out from each 4-bit adder

    // Instantiate four 4-bit adders
    adder_4bit add0 (
        .a(a[3:0]), .b(b[3:0]), .Cin(c_block[0]),
        .sum(y[3:0]), .Cout(cout_blocks[0]),
        .P(P[0]), .G(G[0])
    );

    adder_4bit add1 (
        .a(a[7:4]), .b(b[7:4]), .Cin(c_block[1]),
        .sum(y[7:4]), .Cout(cout_blocks[1]),
        .P(P[1]), .G(G[1])
    );

    adder_4bit add2 (
        .a(a[11:8]), .b(b[11:8]), .Cin(c_block[2]),
        .sum(y[11:8]), .Cout(cout_blocks[2]),
        .P(P[2]), .G(G[2])
    );

    adder_4bit add3 (
        .a(a[15:12]), .b(b[15:12]), .Cin(c_block[3]),
        .sum(y[15:12]), .Cout(cout_blocks[3]),
        .P(P[3]), .G(G[3])
    );

    // Carry lookahead for block carries
    cla_4block cla (
        .Cin(Cin),
        .P(P),
        .G(G),
        .c(c_block)
    );

    // Final carry out is the carry-out from the last 4-bit adder block
    assign Co = cout_blocks[3];
endmodule