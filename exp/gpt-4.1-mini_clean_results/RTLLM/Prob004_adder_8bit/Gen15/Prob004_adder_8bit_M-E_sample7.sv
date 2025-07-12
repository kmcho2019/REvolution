// 1-bit Full Adder
module fa_1bit (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 2-bit adder block with block propagate and generate signals
module adder_2bit_block (
    input  wire [1:0] a,
    input  wire [1:0] b,
    input  wire       cin,
    output wire [1:0] sum,
    output wire       cout,
    output wire       p_block,
    output wire       g_block
);
    wire c1;
    wire p0, g0, p1, g1;

    // Bit 0 propagate and generate
    assign p0 = a[0] ^ b[0];
    assign g0 = a[0] & b[0];
    fa_1bit fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c1)
    );

    // Bit 1 propagate and generate
    assign p1 = a[1] ^ b[1];
    assign g1 = a[1] & b[1];
    fa_1bit fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(cout)
    );

    // Block propagate and generate signals
    assign p_block = p0 & p1;
    assign g_block = g1 | (p1 & g0);
endmodule

// Top level 8-bit adder using 4 two-bit blocks with hierarchical carry logic
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire c1, c2, c3; // carry between blocks
    wire p0, g0, p1, g1, p2, g2, p3, g3;

    // Instantiate four 2-bit blocks
    adder_2bit_block block0 (
        .a(a[1:0]),
        .b(b[1:0]),
        .cin(cin),
        .sum(sum[1:0]),
        .cout(),   // internal carry unused here
        .p_block(p0),
        .g_block(g0)
    );
    adder_2bit_block block1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .cin(c1),
        .sum(sum[3:2]),
        .cout(),
        .p_block(p1),
        .g_block(g1)
    );
    adder_2bit_block block2 (
        .a(a[5:4]),
        .b(b[5:4]),
        .cin(c2),
        .sum(sum[5:4]),
        .cout(),
        .p_block(p2),
        .g_block(g2)
    );
    adder_2bit_block block3 (
        .a(a[7:6]),
        .b(b[7:6]),
        .cin(c3),
        .sum(sum[7:6]),
        .cout(cout),
        .p_block(p3),
        .g_block(g3)
    );

    // Hierarchical carry calculation between blocks (4 blocks)
    // c1 = g0 | (p0 & cin)
    // c2 = g1 | (p1 & c1)
    // c3 = g2 | (p2 & c2)
    assign c1 = g0 | (p0 & cin);
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);
endmodule