module CLA4 (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       g_out,
    output       p_out,
    output       cout,
    output       carry_into_msb
);
    wire [3:0] p = a ^ b;      // propagate
    wire [3:0] g = a & b;      // generate

    wire c1, c2, c3;

    // Carry lookahead logic for 4 bits
    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign cout = g[3] | (p[3] & c3);

    assign sum = p ^ {c3, c2, c1, cin};
    assign g_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_out = &p; // all propagate
    assign carry_into_msb = c3; // carry into MSB of this 4-bit block
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire g0, p0, g1, p1;
    wire c4;   // carry between lower 4-bit and upper 4-bit blocks
    wire cout;
    wire carry_into_msb;

    wire [3:0] sum_low, sum_high;
    wire c3_low, c3_high; // carry into MSB of each 4-bit block

    // Lower 4 bits CLA
    CLA4 cla_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum_low),
        .g_out(g0),
        .p_out(p0),
        .cout(),         // carry out from lower 4-bit
        .carry_into_msb(c3_low)
    );

    // Compute carry into upper 4-bit block
    assign c4 = g0 | (p0 & 1'b0); // cin = 0

    // Upper 4 bits CLA
    CLA4 cla_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum_high),
        .g_out(g1),
        .p_out(p1),
        .cout(cout),      // final carry out
        .carry_into_msb(c3_high)
    );

    assign s = {sum_high, sum_low};
    assign carry_into_msb = c3_high;

    // Overflow: XOR of carry into and carry out of MSB
    assign overflow = carry_into_msb ^ cout;

endmodule