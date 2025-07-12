module FourBitCLA (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       group_p, // group propagate
    output       group_g, // group generate
    output       carry_into_msb // carry into bit 3
);
    wire [3:0] p; // propagate signals
    wire [3:0] g; // generate signals
    wire [4:0] c; // carry signals

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];
    assign carry_into_msb = c[3]; // carry into bit 3

    // group propagate = all bits propagate
    assign group_p = &p;
    // group generate = generate or propagate and previous generate
    assign group_g = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire c4;               // carry from lower 4-bit adder
    wire group_p0, group_g0; // lower group propagate and generate
    wire group_p1, group_g1; // upper group propagate and generate

    wire cout0, cout1;
    wire carry_into_msb0, carry_into_msb1;

    // Lower 4-bit CLA
    FourBitCLA cla0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(s[3:0]),
        .cout(cout0),
        .group_p(group_p0),
        .group_g(group_g0),
        .carry_into_msb(carry_into_msb0)
    );

    // Compute carry into upper 4-bit group
    // c4 = group_g0 | (group_p0 & cin)
    // cin=0, so c4 = group_g0
    assign c4 = group_g0;

    // Upper 4-bit CLA
    FourBitCLA cla1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(s[7:4]),
        .cout(cout1),
        .group_p(group_p1),
        .group_g(group_g1),
        .carry_into_msb(carry_into_msb1)
    );

    // Overflow = carry into MSB bit 7 xor carry out of MSB
    assign overflow = carry_into_msb1 ^ cout1;

endmodule