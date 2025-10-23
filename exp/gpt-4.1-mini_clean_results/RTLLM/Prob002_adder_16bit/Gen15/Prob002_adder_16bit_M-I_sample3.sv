module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p; // propagate = a xor b
    wire [7:0] g; // generate  = a and b

    // Group propagate and generate signals for carry lookahead
    wire [1:0] P_group;
    wire [1:0] G_group;

    wire [8:0] carry;

    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic at 4-bit granularity inside 8-bit block

    // Divide bits into two 4-bit groups
    // Group 0: bits 0-3
    // Group 1: bits 4-7

    // Group propagate: P_group[i] = &p of bits in group i
    assign P_group[0] = &p[3:0];
    assign P_group[1] = &p[7:4];

    // Group generate: G_group[i] = g of highest bit OR (p of highest bit AND ... OR g of lower bits)
    // Carry lookahead for 4-bit group is:
    // G4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)

    assign G_group[0] =
        g[3] |
        (p[3] & g[2]) |
        (p[3] & p[2] & g[1]) |
        (p[3] & p[2] & p[1] & g[0]);

    assign G_group[1] =
        g[7] |
        (p[7] & g[6]) |
        (p[7] & p[6] & g[5]) |
        (p[7] & p[6] & p[5] & g[4]);

    // Compute carries at group boundaries
    assign carry[0] = Cin;

    // carry[4] = G_group[0] | (P_group[0] & carry[0])
    assign carry[4] = G_group[0] | (P_group[0] & carry[0]);

    // carry[8] = G_group[1] | (P_group[1] & carry[4])
    assign carry[8] = G_group[1] | (P_group[1] & carry[4]);

    // Compute internal carries within each 4-bit group using simple lookahead

    // Bits 0-3 carries (carry[1] to carry[3])
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);

    // Bits 4-7 carries (carry[5] to carry[7])
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);

    // Sum bits
    assign y = p ^ carry[7:0];
    assign Co = carry[8];

endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule